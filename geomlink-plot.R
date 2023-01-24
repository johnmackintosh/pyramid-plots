library(dplyr)
library(data.table)
library(ggplot2)
library(headliner)

plot_ceiling <- function(x, divisor = 10) {
  res <- ceiling(max(x, na.rm = TRUE) / divisor) * divisor
}

align_caption_left <-  ggplot2::theme(plot.caption.position = "plot",
                                      plot.caption = ggplot2::element_text(hjust = 0),
                                      plot.margin = ggplot2::margin(0.1, 2.6, 0.1, 0.1, "cm"))


HSCPval <- "Inverness"
year_start <- 2018
year_end <- 2030
floor_factor <- 1000
year_start_col <-  "#231aff"
year_end_col <-  "#C71585"
chart_caption <-  "Source: Improvement Service Population Projections for Sub Council Areas 2018 based"
    
    
    projected <- fread("https://raw.githubusercontent.com/johnmackintosh/pyramid-plots/main/source_data/projected.csv", 
                       colClasses = c("character","character","integer"))
    
    maxval <- plot_ceiling(projected$pop, floor_factor)
    
    
    t1 <- projected[year == 2018]
    t2 <- projected[year == 2030] 
    t1[, `:=`(pop2030 = t2$pop, year2 = t2$year)]
    
    
    
    chart_text <- t1 %>% 
      add_headline_column( x = pop2030, 
                           y = pop, 
                           headline = "population in the {ageband} ageband will {trend} by {delta_p}%  ({f(x)} vs {f(y)})", 
                           f = scales::number_format(big.mark = ","))   
    
    chart_text <- chart_text  %>% 
      add_headline_column(x = pop2030, 
                          y = pop,
                          headline = "{delta_p}%", 
                          .name = "headline2")
    
    chart_text <- chart_text  %>% 
      add_headline_column(x = pop2030, 
                          y = pop,
                          headline = "{delta_p}", 
                          .name = "headline3")
    
    chart_text <- chart_text  %>% 
      add_headline_column(x = pop2030, 
                          y = pop,
                          headline = "{trend}", 
                          .name = "headline4",  
                          f = scales::number_format(big.mark = ","))
    
    chart_text <- chart_text  %>% 
      add_headline_column(x = pop2030, 
                          y = pop,
                          headline = "{f(x)} vs {f(y)}", 
                          .name = "headline5",  
                          f = scales::number_format(big.mark = ","))
    



    
    
    para_text <- glue::glue("{HSCPval} populations in the  ",
                            "65-74, 75-84, and 85+ agebands will increase by ",
                            chart_text$headline2[4],
                            ", ",
                            chart_text$headline2[5],
                            " and ",
                            chart_text$headline2[6],
                            " respectively")   
    
t1$percent <- as.numeric(chart_text$headline3)/100   
t1$direction <- chart_text$headline4
t1$colours <- if_else(t1$direction =="increase",  year_end_col, year_start_col)
t1$percent <- if_else(t1$direction =="increase",t1$percent, t1$percent *-1)
t1$direction <- if_else(t1$direction =="increase","Increase", "Decrease")
  
 index <- c(0, 0.25, 0.5, 0.75, 1)
   
ggplot(data = t1, aes(x = pop2030, y = percent)) +
  ggforce::geom_link(aes(x = pop,
                xend = pop2030,
                yend = percent,
                alpha = stat(index)), 
            colour = "white", 
            lineend = "round",
            show.legend = F) +
   geom_point(aes(colour = direction), size = 4) +
  ggrepel::geom_text_repel(aes(label = ageband), 
                  size = 3.5, 
                  colour = "white", 
                  family = "Century Gothic") +
  scale_y_continuous("Percent increase or decrease", 
                     labels = scales::percent_format(accuracy = 1), 
                     breaks = c(-0.2,0, 0.2, 0.4, 0.6, 0.8, 1)) + 
 expand_limits(y = c(-.2, 1)) +
  ggplot2::scale_colour_manual(name = "",
                             values = setNames(c( year_end_col,year_start_col),
                                               c("Increase", "Decrease"))) +
  theme_minimal() + 
  theme(legend.position = "right", 
        panel.grid.minor = element_blank(),
        plot.background = element_rect(fill = "#141622"),
        panel.background = element_rect(fill = "#141622", 
                                        colour = "#141622",
                                        size = 2, 
                                        linetype = "solid"),
        panel.grid.major = element_line(size = 0.5, 
                                        linetype = 'solid',
                                        colour = "gray30"),
        axis.title.x = element_text(size = 13, 
                                    face = "bold", 
                                    colour = "white", 
                                    family = "Century Gothic"),
        axis.title.y = element_text(size = 13, 
                                    face = "bold", 
                                    colour = "white", 
                                    family = "Century Gothic"),
        axis.text.x = element_text(colour = "white"),
        axis.text.y = element_text(colour = "white"),
        plot.title = element_text(face = "bold", 
                                  colour = "white", 
                                  size = 14, 
                                  family = "Century Gothic"),
        plot.subtitle = element_text(colour = "white", 
                                     family = "Century Gothic", 
                                     size = 10),
        plot.caption = element_text(colour = "white", 
                                    family = "Century Gothict", 
                                    size = 10),
        plot.caption.position = "plot",
        legend.title = element_text(colour = "white", 
                                    family = "Century Gothic", 
                                    size = 14),
        legend.text = element_text(colour = "white", 
                                   family = "Century Gothic", 
                                   size = 14)) + 
  labs(x = "Projected population in 2030",
       title = para_text, 
       caption = chart_caption)
       ) 
