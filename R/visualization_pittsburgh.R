# This file provides utility functions to create the interactive map of Pittsburgh in RMarkdown
library(dplyr)
library(ggplot2)
library(readr)
library(sp)
library(sf)
library(ggmap)
library(grid)
library(ggplotify)
library(plotly)


here::i_am("R/visualization_pittsburgh.R")
library(here)

# Use the previously-calculated bound to create an opaque square with a circular cutout
# This masks the square ggmap, only displaying the inner circle
bound <- readRDS(here("data","bound.rds"))
extent <- st_bbox(bound)
outside <- st_as_sfc(extent)
inside <- bound$geometry[1]
cutout <- st_difference(outside, inside)

# Download a basemap for Pittsburgh from ggmap
extent <- c(left = extent[["xmin"]], bottom = extent[["ymin"]], right = extent[["xmax"]], top = extent[["ymax"]])
m <- get_stamenmap(extent, zoom=10, maptype = "toner-background")

# Display the map
points <- data.frame(race = c("white", "black", "hispanic", "asian", "other"), 
                     geometry=c(st_combine(read_rds(here("data","sampled_white.rds"))), 
                                st_combine(read_rds(here("data","sampled_black.rds"))), 
                                st_combine(read_rds(here("data","sampled_hispanic.rds"))), 
                                st_combine(read_rds(here("data","sampled_asian.rds"))), 
                                st_combine(read_rds(here("data","sampled_other.rds")))), 
                     color=c("#ffb262", "#129e56","#7570b3","#e7298a", "#43a8b5"))
points$race <- factor(points$race, levels = points$race, ordered=T)

# Build the map of Pittsburgh's surrounding area
construct_map <- function(metro_grades, bound, blocks_buffer){
  pt_sz <- 0.001
  
  ggmap(m) +
    geom_sf(data = cutout, mapping = aes(geometry=geometry), color="white", fill="white", inherit.aes = FALSE) +
    geom_sf(data = as.data.frame(bound), mapping = aes(geometry=geometry), color="black", fill=NA, lwd = 0.5, inherit.aes = FALSE) +
    geom_sf(data = points, mapping = aes(geometry=geometry, color=race), size=0.001, alpha=0.5, inherit.aes = FALSE, show.legend=F) + 
    scale_color_manual(values = points$color) +
    labs(title = "Pittsburgh's Surrounding Area") +
    theme_void() + theme(plot.title=element_text(margin = margin(b=10), hjust = 0.45))
  
}

# Construct the Pennsylvania decorative material
construct_PA <- function(states, metro_grades){
  PA <- states %>% filter(NAME == "Pennsylvania")
  
  city_loc <- data.frame(geometry=st_as_sf(eval(str2expression((metro_grades %>% filter(metro_area == "Pittsburgh, PA"))$centroid))))
  
  ggplot() + 
    geom_sf(data = PA, mapping = aes(geometry=geometry)) +
    geom_sf(data = city_loc, mapping = aes(geometry=geometry), size=5, color="black") + 
    geom_sf(data = city_loc, mapping = aes(geometry=geometry), size=3, color="darkgray") + 
    theme_void()
}

# Construct bar plot under the map for each HOLC grade
bar_grade <- function(metro_grades, grade){
  holc_pct <- as.data.frame(t(metro_grades %>% 
                                filter(metro_area == "Pittsburgh, PA", holc_grade == grade) %>% 
                                select(pct_white, pct_black, pct_hisp, pct_asian, pct_other)))
  colnames(holc_pct) <- "Percentage"
  holc_pct$Percentage <- round(holc_pct$Percentage, digits = 1)
  holc_pct$Race <- c("White", "Black", "Latino", "Asian", "Other")
  holc_pct$Race <- factor(holc_pct$Race, levels=rev(c("White", "Black", "Latino", "Asian", "Other")))
  holc_pct$Race2 <- holc_pct$Race # Need this so "Race" isn't duplicated due to grouping on ggplot
  holc_pct$tmp <- factor("1", level=c("0","1"))
  holc_pct$tmp_lab <- factor("1", level=c("0","1"))
  holc_pct$label_loc <- cumsum(holc_pct$Percentage) - holc_pct$Percentage / 2
  holc_pct$label <- paste(holc_pct$Race, " - ", holc_pct$Percentage, "%", sep="")
  
  p <- ggplot() + geom_bar(data=holc_pct, aes(x = Percentage, y = tmp, fill = Race, group = Race2), color="white", lwd=1, width=0.2, position="stack", stat="identity", show.legend=F) +
    geom_text(data=filter(holc_pct, Percentage > 6), aes(x = label_loc, y = tmp_lab, label = label), position = position_nudge(x = 0, y = -0.2), size = 4) +
    theme_void() +
    scale_fill_manual(values = rev(c("#ffb262", "#129e56","#7570b3","#e7298a", "#43a8b5")))
  
  holc_bar <- ggplotly(p, tooltip = c("Percentage", "Race"), autosize = F, width = 800, height = 200) %>%
    layout(
      showlegend = F, 
      legend = list(orientation = 'h'),
      yaxis = list(
        color = '#ffffff',
        gridcolor = '#ffff'),
      xaxis = list(
        color = '#ffffff',
        gridcolor = '#ffff')
    )
  
  holc_bar
}

# Construct bar plot under the surrounding area map showing the total population distribution by race
construct_surrounding_bar <- function(blocks_buffer){
  
  # Calculate the total number of each race and clean data to be in bar plot format
  surrounding_counts <- blocks_buffer %>% 
    summarize(white = sum(white),
              black = sum(black),
              hispanic = sum(hispanic),
              asian = sum(asian),
              other = sum(other_race))
  surrounding_pct <- as.data.frame(t(round(surrounding_counts / sum(surrounding_counts), digits = 3)*100))
  colnames(surrounding_pct) <- "Percentage"
  surrounding_pct$Race <- c("White", "Black", "Latino", "Asian", "Other")
  surrounding_pct$Race <- factor(surrounding_pct$Race, levels=rev(c("White", "Black", "Latino", "Asian", "Other")), ordered = T)
  surrounding_pct$tmp <- factor("1", level=c("0","1"))
  surrounding_pct$tmp_lab <- factor("1", level=c("0","1"))
  surrounding_pct$label_loc <- cumsum(surrounding_pct$Percentage) - surrounding_pct$Percentage / 2
  surrounding_pct$label <- paste(surrounding_pct$Race, " - ", surrounding_pct$Percentage, "%", sep="")
  
  # Create static plot
  p <- ggplot() + geom_bar(data=surrounding_pct, aes(x = Percentage, y = tmp, fill = Race), color="white", lwd=1, width=0.2, stat="identity", show.legend=F) +
    geom_text(data=filter(surrounding_pct, Race %in% c("White", "Black")), aes(x = label_loc, y = tmp_lab, label = label), position = position_nudge(x = 0, y = -0.15), size = 4) +
    theme_void() +
    scale_fill_manual(values = rev(c("#ffb262", "#129e56","#7570b3","#e7298a", "#43a8b5")))
  
  # Add interactivity using Plotly
  surrounding_bar <- ggplotly(p, tooltip = c("Percentage", "Race"), width = 800, height = 200) %>%
    layout(
      showlegend = F, 
      legend = list(orientation = 'h'),
      yaxis = list(
        color = '#ffffff',
        gridcolor = '#ffff'),
      xaxis = list(
        color = '#ffffff',
        gridcolor = '#ffff')
    )
  
}

# The grid package allows us to print grobs to the graphics device by manipulating the viewport
# The ggplotify package allows us to turn arbitrary ggplot objects into grobs
# Both of these we use in the following function to overlay plots created with geom_sf previously
construct_surrounding_plot <- function(metro_grades, bound, blocks_buffer, PA_plot){
  grid.newpage()
  grid.draw(as.grob(construct_map(metro_grades, bound, blocks_buffer)))
  # Place Pennsylvania in the correct frame of reference relative to the surrounding area
  sample_vp <- viewport(x = 0.6, y = 0.05, 
                        width = 0.25, height = 0.25,
                        just = c("left", "bottom"),
                        angle = 15)
  pushViewport(sample_vp)
  grid.draw(as.grob(PA_plot))
  popViewport()
}

# Create individual HOLC maps for each grade
construct_holc_map <- function(){
  # Construct HOLC plots
  holc_plots <- list()
  
  grades <- c(A = "Best", B = "Desirable", C = "Declining", D = "Hazardous")
  
  for(i in c("A","B","C","D")){
    points[[i]] <- c(st_combine(read_rds(here("data", sprintf("sampled_white_%s.rds", i)))),
                     st_combine(read_rds(here("data", sprintf("sampled_black_%s.rds", i)))),
                     st_combine(read_rds(here("data", sprintf("sampled_hispanic_%s.rds", i)))),
                     st_combine(read_rds(here("data", sprintf("sampled_asian_%s.rds", i)))),
                     st_combine(read_rds(here("data", sprintf("sampled_other_%s.rds", i))))
    )
    
    holc_plots[[i]] <- ggmap(m) +
      geom_sf(data = cutout, mapping = aes(geometry=geometry), color="white", fill="white", inherit.aes = FALSE) +
      geom_sf(data = bound, mapping = aes(geometry=geometry), color="black", fill=NA, lwd = 0.5, inherit.aes = FALSE) +
      geom_sf(data = points, mapping = aes(geometry=.data[[i]], color=race), size=0.01, inherit.aes = FALSE, show.legend=F) + 
      labs(title = sprintf("Pittsburgh's %s Zones", grades[[i]])) + 
      scale_color_manual(values = c("#ffb262", "#129e56","#7570b3","#e7298a", "#43a8b5")) +
      theme_void() + theme(plot.title=element_text(margin = margin(b=10), hjust = 0.45))
  }
  holc_plots
}






