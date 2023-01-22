library(dplyr)
library(purrr)
library(ggplot2)
library(scatterpie)
library(gridExtra)
library(sf)

us_scatterpie_grid <- function(metro_grades, states){
  
  nation_pie <- function(metro_grades, grade){
    metros_A <- metro_grades %>% filter(holc_grade == grade)
    
    # Turn the points into longitude and latitude so we can repel the points on the ggplot
    metros_A$lon <- map_dbl(metros_A$centroid, function(x){eval(str2expression(x))[[1]]})
    metros_A$lat <- map_dbl(metros_A$centroid, function(x){eval(str2expression(x))[[2]]})
    metros_A$pct_nonwhite <- 100 - metros_A$pct_white
    metros_A$rad <- (metros_A$value^(1/3)) / 200
    
    mas <- metros_A %>% select(lon, lat, pct_white, pct_nonwhite, value, rad) %>% arrange(desc(value))
    
    end <- nrow(mas)
    for(i in 1:(nrow(mas)-1)){
      cur <- mas[i,]
      lon_dist <- cur$lon - mas$lon[(i+1):end]
      lat_dist <- cur$lat - mas$lat[(i+1):end]
      dists <- sqrt((lon_dist)^2 + (lat_dist)^2)
      
      move <-  mas$rad[i] / dists
      move[move <= 1] <- 0
      
      mas$lon[(i+1):end] <- mas$lon[(i+1):end] - lon_dist*move
      mas$lat[(i+1):end] <- mas$lat[(i+1):end] - lat_dist*move
    }
    
    title <- ifelse(grade == "A", "Best", "Hazardous")
    
    ggplot() + 
      ggtitle(title) + 
      geom_sf(data=filter(states, !(NAME %in% c("Alaska", "Hawaii", "Puerto Rico"))) , mapping = aes(geometry = geometry)) +
      #geom_jitter(data=metros_A, mapping = aes(x = lon, y = lat)) + 
      geom_scatterpie(data=mas, 
                      mapping = aes(x = lon, y = lat, r = rad), 
                      cols=c("pct_white", "pct_nonwhite"), 
                      color = "white", show.legend=F) + 
      scale_fill_manual(values = c("#ffb262","#808285")) +
      theme_void() + 
      theme(plot.title = element_text(hjust = 0.5))
  }
  
  A <- nation_pie(metro_grades, "A")
  D <- nation_pie(metro_grades, "D")
  grid.arrange(A, D, nrow=1)
  
}

us_scatterpie_grid
