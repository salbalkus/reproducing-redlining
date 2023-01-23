# This file downloads and saves the FiveThirtyEight article data from their GitHub repository and merges with Census geometries

library(here)
library(readr)
library(tidycensus)
library(sf)

# Set proper file path
here::i_am("R/download_538_data.R")
library(here)

### Metro Grades ###
dest <- here("data", "metro-grades.csv")

# Download files
metro_grades <- read_csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/redlining/metro-grades.csv")

# Get the total geography of each metro area
metros <- get_decennial(geography = "cbsa", 
                        variables = c("P2_001N"), 
                        year = 2020, geometry = TRUE)

metros$NAME <- substr(metros$NAME, 1, nchar(metros$NAME)-11) # The 538 data has "Metro Area" and "Micro Area" removed from NAME
metro_grades <- left_join(metro_grades, metros, by=c("metro_area"="NAME")) # associate each metro area with a geography
metro_grades$centroid <- st_centroid(metro_grades$geometry)

write_csv(metro_grades, dest)

### Zone Block Matches ###
dest <- here("data", "zone-block-matches.csv")

# Download files if they do not already exist
zone_matches <- read_csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/redlining/zone-block-matches.csv")
write_csv(zone_matches, dest)
