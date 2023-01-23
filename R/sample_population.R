# This file randomly samples point geometries to represent population from Census block data, in order to construct the Pittsburgh map

library(dplyr)
library(ggplot2)
library(sf)

here::i_am("R/download_census_blocks.R")
library(here)

blocks_buffer <- readRDS(here("data", "blocks_buffer.rds"))

# Take only 10% of the population for computational purposes
samp <- blocks_buffer %>% 
  mutate(
    hispanic = round(hispanic/10),
    white = round(white/10),
    black = round(black/10),
    asian = round(asian/10),
    other_race = round(other_race/10)
  )


print("Sampling Hispanic Population...")
hispanic_path <- here("data","sampled_hispanic.rds")
samp_hispanic <- samp %>% filter(hispanic > 0)
output <- st_sample(samp_hispanic$geometry2, samp_hispanic$hispanic, type="random", exact=F)
saveRDS(output, file = hispanic_path)


print("Sampling Other Race Population...")
other_path <- here("data","sampled_other.rds")
samp_other <- samp %>% filter(other_race > 0)
output <- st_sample(samp_other$geometry2, samp_other$other_race, type="random", exact=F)
saveRDS(output, file = other_path)


print("Sampling Asian Population...")
asian_path <- here("data","sampled_asian.rds")
samp_asian <- samp %>% filter(asian > 0)
output <- st_sample(samp_asian$geometry2, samp_asian$asian, type="random", exact=F)
saveRDS(output, file = asian_path)


print("Sampling Black Population...")
black_path <- here("data","sampled_black.rds")
samp_black <- samp %>% filter(black > 0)
output <- st_sample(samp_black$geometry2, samp_black$black, type="random", exact=F)
saveRDS(output, file = black_path)


print("Sampling White Population...")
white_path <- here("data","sampled_white.rds")
samp_white <- samp %>% filter(white > 0)
output <- st_sample(samp_white$geometry2, samp_white$white, type="random", exact=F)
saveRDS(output, file = white_path)


