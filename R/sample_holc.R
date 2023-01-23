# This file provides a function that randomly samples population point geometries for the Pittsburgh map for each race using the Census bureau data

library(readr)
library(dplyr)

here::i_am("R/sample_holc.R")
library(here)

# Sample from every map grade
map_grade <- function(df, grade){
  
  samp <- df %>% filter(holc_grade == grade)
  print(sprintf("Saving Hispanic %s...", grade))
  hispanic_path <- here("data",sprintf("sampled_hispanic_%s.rds", grade))
  samp_hispanic <- samp %>% filter(hispanic > 0)
  output <- st_sample(samp_hispanic$geometry2, samp_hispanic$hispanic, type="random", exact=F)
  saveRDS(output, file = hispanic_path)


  print(sprintf("Saving Other %s...", grade))
  other_path <- here("data",sprintf("sampled_other_%s.rds", grade))
  samp_other <- samp %>% filter(other_race > 0)
  output <- st_sample(samp_other$geometry2, samp_other$other_race, type="random", exact=F)
  saveRDS(output, file = other_path)
  

  print(sprintf("Saving Asian %s...", grade))
  asian_path <- here("data",sprintf("sampled_asian_%s.rds", grade))
  samp_asian <- samp %>% filter(asian > 0)
  output <- st_sample(samp_asian$geometry2, samp_asian$asian, type="random", exact=F)
  saveRDS(output, file = asian_path)
  

  print(sprintf("Saving Black %s...", grade))
  black_path <- here("data",sprintf("sampled_black_%s.rds", grade))
  samp_black <- samp %>% filter(black > 0)
  output <- st_sample(samp_black$geometry2, samp_black$black, type="random", exact=F)
  saveRDS(output, file = black_path)
  

  print(sprintf("Saving White %s...", grade))
  white_path <- here("data",sprintf("sampled_white_%s.rds", grade))
  samp_white <- samp %>% filter(white > 0)
  output <- st_sample(samp_white$geometry2, samp_white$white, type="random", exact=F)
  saveRDS(output, file = white_path)
}

