# This file calculates the circular buffer zone for the Pittsburgh map, and determines which Census blocks are contained within it

library(readr)
library(dplyr)
library(smoothr)
library(sf)

here::i_am("R/download_census_blocks.R")
library(here)

# Load the data necessary for the buffer zone
zone_matches <- read_csv(here("data", "zone-block-matches.csv"))
blocks <- readRDS(here("data", "blocks.rds"))

# Filter for the blocks mapped by HOLC
holc_blocks <- inner_join(zone_matches, blocks, by=c("block_geoid20"="GEOID"))

# Select and reformat Pittsburgh
pitt <- holc_blocks %>% filter(holc_city == "Pittsburgh")

# Construct a circle around the centroid of the given area, with a percentage buffer
circumscribe <- function(df, pct=0.1){
  geo <- df %>% st_as_sf() %>% arrange(block_geoid20)
  # Compute the convex hull
  hull <- geo %>% st_convex_hull()
  
  # Compute centroids
  geo_center <- st_centroid(hull)
  
  # Add centroid, then cast hull to points
  hull_points <- hull %>% 
    mutate(centroid_geometry = geo_center$geometry) %>%
    st_cast("POINT")
  
  # Compute distance from centroid to all points in hull
  hull_points$dist_to_centroid <- as.numeric(hull_points %>% 
                                               st_distance(hull_points$centroid_geometry, by_element = TRUE))
  
  # Pick the hull point the furthest distance from the centroid
  hull_max <- hull_points %>% 
    arrange(block_geoid20) %>%
    group_by(block_geoid20) %>%
    summarize(max_dist = max(dist_to_centroid)) %>% 
    ungroup()
  
  
  # Draw a circle using that distance
  diam <- hull_max$max_dist * (1 + pct)
  geo_circumscribed <- smooth(st_buffer(geo_center, diam), method="ksmooth", smoothness=10)
  return(geo_circumscribed)
}

### Calculate the geometric difference and compute the percentage of each census block contained within the bound

# Combine into one shape for circumscribing
combined_geo <- pitt %>% summarize(st_combine(geometry))
colnames(combined_geo) <- "geometry"
combined_geo$block_geoid20 <- "1"
# Draw a circle with 10% buffer around the HOLC region
bound <- circumscribe(combined_geo)


# Perform geometric calculations and save to file
filtered_blocks_file <- here("data", "blocks_buffer.rds")
bound_file <- here("data", "bound.rds")

# First filter out all blocks which do not intersect the circular bound
# Then, crop all blocks to the bound
# Finally, calculate area of each block remaining in the bound
blocks_buffer <- blocks %>% 
  filter(st_intersects(geometry, bound, sparse=F)) %>% 
  mutate(geometry2 = st_intersection(geometry, bound))

blocks_buffer$pct_area <- as.numeric(st_area(blocks_buffer$geometry2) / st_area(blocks_buffer$geometry))

blocks_buffer <- blocks_buffer %>%
  mutate(hispanic = round(P2_002N*pct_area),
       white = round(P2_005N*pct_area),
       black = round(P2_006N*pct_area),
       asian = round(P2_008N*pct_area),
       other_race = round((P2_007N + P2_009N + P2_010N + P2_011N)*pct_area)
)
  
saveRDS(blocks_buffer, filtered_blocks_file)
saveRDS(bound, bound_file)

