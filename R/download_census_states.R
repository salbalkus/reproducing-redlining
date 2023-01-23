# This file downloads and saves state-level geometries from the Census Bureau

here::i_am("R/download_census_states.R")
library(here)
library(tidycensus)

states_file <- here("data", "states.rds")

### Census States ###
states <- get_decennial(geography = "state", 
                        variables = c("STATE"), 
                        year = 2020, geometry = TRUE)

# Manually cache the data to avoid downloading again
saveRDS(states, file = states_file)
