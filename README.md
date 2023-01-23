# reproducing-redlining
An attempt to reproduce the figures in the FiveThirtyEight article "[The Lasting Legacy of Redlining](https://projects.fivethirtyeight.com/redlining/)" originally authored by Ryan Best and Elena Mejía. I use the data for the project from the [FiveThirtyEight GitHub repository](https://github.com/fivethirtyeight/data/tree/master/redlining) as well as the 2020 Census, accessed through the `tidycensus` package. 

This project attempts to reproduce the following three figures:

1. Bar plot of Cleveland's racial disparities in redlining (beginning of article)
2. Pie chart map comparing "Hazardous" and "Best" racial disparities across all of the cities with avaible HOLC data in the U.S. (beginning of article)
3. Map of Pittsburgh showing population density of each race across HOLC grades (first of the series of city maps)

# Results

## Viewing
If you are simply interested in viewing my attempt at reproducing the figures from the article, they are located in `results/output.html`. To view them, simply download the `results/output.html` file and open in a browser (such as Chrome). You can also clone the repository and open the `results/output.html` file from there. The `result/output.html` is produced by knitting the `scripts/driver.Rmd` script. Interim steps are produced by code in the **R** folder. Please see below for more details on how the figures were reproduced and how to rerun the code and analysis.

## Reflection

While most of the data required to reproduce the figures from this article was available, actually constructing the figures in R was a challenge. It was fairly obvious that the figures were not only bespoke, but also highly complex - and with no external code available, cobbling together such complicated figures was difficult. Some visualization parameters - such the exact method for constructing the bounds of Pittsburgh map plot - were unclear. R also did not support the type of visualization needed to map the pie-charts on the U.S. map, which made it impossible to replicate perfectly.

If I had to rate the reproducibility of this article, I would give it a 5/10. The data was available, but creating the figures and developing reproducible code was no easy task. I even attempted to host my reproduction using CodeOcean, but the R packages that I needed to use to construct the dynamic geospatial visualizations in RMarkdown using `sf` and `pandoc` did not play nice with the site's output interface and were not able to be run correctly. If I were to do this project over again, I would have instead attempted to use a more advanced data visualization package like D3.js, which probably would have been more reproducible for such complex plots.

# How to Run Code

There are two ways to reproduce the results here, which are listed below. *One warning*: Regenerating the data from scratch using `scripts/driver.R` or `scripts/driver.Rmd` may potentially take up to about 30 minutes to complete.

## Recommended: Run `scripts/driver.R`

The `scripts/driver.R` file should automatically knit the visualizations to html. To run this script, simply:

1. Clone this Git repository to your local machine.
2. If necessary, install any packages listed under "Dependencies" below that you do not already have installed or are not automatically installed by `pacman`. NOTE: if not already installed, it may be necessary to download `sf` and `tidycensus` from the RStudio command line, as some of *their* dependencies may need to be built from source. Agree to any prompts provided by RStudio.
3. Run `scripts/driver.R` either in RStudio or from the command line by navigating to the repository using `cd` and running `Rscript scripts/driver.R`


## Open and run individual code cells from the `scripts/driver.Rmd`

The `scripts/driver.Rmd` file runs each step of the simulation and saves the output to the **data** folder. To reproduce individual steps of the analysis, do the following:

1. Clone this Git repository to your local machine.
2. If necessary, install any packages listed under "Dependencies" below that you do not already have installed.
3. Open `scripts/driver.Rmd` in RStudio and run the desired cells corresponding to the steps of the analysis that you would like to reproduce.

Also, knitting `scripts/driver.Rmd` to an .html file manually in RStudio will run the entire file and reproduce the results (albeit in the same folder in which the RMarkdown file is knitted.

# Dependencies:
```
dplyr=1.0.10
ggmap=3.0.1
ggplot2=3.4.0
ggplotify=0.1.0
grid
gridExtra=2.3
here=1.0.1
plotly=4.10.1
purrr=1.0.1
readr=2.1.3
rmarkdown=2.20
scatterpie=0.1.8
sf
sp=1.6-0
tidycensus
tidyr=1.2.1

```

# Contents

- **data**: Stores data downloads and intermediate steps of the analysis. Note that due to file size sharing restrictions, I only include the first step of downloads. 
- **R**: Code to run each intermediate step of the analysis. These are implemented in the driver script.
- **scripts**: Stores the *driver.Rmd* RMarkdown script that reproduces the visualizations from the FiveThirtyEight article, as well as *driver.R* which automatically knits *driver.Rmd* when run from the command line.
- **results**: Contains the reproduced visualizations from the article in the form of a .html file.
- **environment**: Contains a Dockerfile and associated files in case users want to build a Docker image containing the necessary repositories.
