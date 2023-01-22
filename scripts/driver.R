if (!require("pacman")) install.packages("pacman", repos = "http://cran.us.r-project.org")
pacman::p_load("here", "rmarkdown",
               "readr", "dplyr", "ggplot2", "tidyr", "purrr",
               "sp", "sf", "smoothr", "scatterpie",
               "tidycensus", "ggmap", "grid", "gridExtra", "ggplotify", "plotly",
               )

library(rmarkdown)
setwd(dirname(sys.frame(1)$ofile))
here::i_am("scripts/driver.R")
library(here)
render(here('scripts', 'driver.rmd'), output_file=here('results', 'output.html'))




