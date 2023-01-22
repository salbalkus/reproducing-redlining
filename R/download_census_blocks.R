library(tidyr)

here::i_am("R/download_census_blocks.R")
library(here)

blocks_file <- here("data", "blocks.rds")

### Census Blocks ###
blocks <- get_decennial(geography = "block", 
                          state="Pennsylvania",
                          variables = c("P2_001N", # Total
                                        "P2_002N", # Total Hispanic or Latino
                                        "P2_005N", # Total Non-Hispanic White
                                        "P2_006N", # Total Non-Hispanic Black
                                        "P2_007N", # Total Non-Hispanic Indian
                                        "P2_008N", # Total Non-Hispanic Asian
                                        "P2_009N", # Total Non-Hispanic Islander
                                        "P2_010N", # Total Non-Hispanic Other
                                        "P2_011N"), # Total Non-Hispanic two or more races
                          year = 2020, geometry = TRUE) %>% 
pivot_wider(names_from = variable, values_from = value)
  
# Manually cache the data to avoid downloading again
saveRDS(blocks, file = blocks_file)