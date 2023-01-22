library(ggplot2)
library(dplyr)
library(tidyr)

cleveland_bar <- function(metro_grades){
  cleveland <- metro_grades %>% filter(metro_area == "Cleveland-Elyria, OH") %>% select(holc_grade, pct_white, pct_black, pct_hisp, pct_asian, pct_other) %>% pivot_longer(pct_white:pct_other)
  cleveland$holc_grade <- factor(cleveland$holc_grade, levels=rev(c("A","B","C","D")))
  cleveland$holc_grade <- recode(cleveland$holc_grade, A="\"Best\"", B="\"Desirable\"", C="\"Declining\"", D="\"Hazardous\"")
  cleveland$name <- recode(cleveland$name, pct_white="White", pct_black="Black", pct_hisp="Latino", pct_asian="Asian", pct_other = "Other")
  cleveland$name <- factor(cleveland$name, levels=rev(c("White", "Black", "Latino", "Asian", "Other")))
  
  ggplot(cleveland) + geom_bar(aes(x = value, y = holc_grade, fill = name), color="white", lwd=1, width=0.8, stat="identity", show.legend=T) +
    theme_void() +
    theme(axis.text.y = element_text(),
          legend.position="top",
          legend.title=element_blank()) +
    scale_fill_manual(guide=guide_legend(reverse=T), values = rev(c("#ffb262", "#129e56","#7570b3","#e7298a", "#43a8b5")))
}