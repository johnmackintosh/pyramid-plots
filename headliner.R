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

p <- ggplot2::ggplot(projected, aes(ageband, pop, fill = year)) +
  ggplot2::geom_col(position = "dodge") +
  ggplot2::labs(x = " ",
                y = "Number of people",
                caption = chart_caption ) +
  ggplot2::scale_fill_manual(name = "",
                             values = setNames(c(year_start_col, year_end_col),
                                               c(year_start, year_end)))

if (!HSCPval == "Inverness") {
  p <-  p +  ggplot2::scale_y_continuous(limits = c(0, maxval),
                                         breaks = seq(0, maxval, by = 1000),
                                         labels = scales::comma)
  
}

if (HSCPval == "Inverness") {
  p <-  p +  ggplot2::scale_y_continuous(limits = c(0, maxval),
                                         breaks = seq(0, maxval, by = 5000),
                                         labels = scales::comma)
  
}



p <- p +
  ggplot2::coord_flip(clip = "off") +
  ggplot2::theme_minimal() +
  ggplot2::theme(legend.position = "top") +
  align_caption_left +
  ggExtra::removeGridY()

p

t1 <- p$data[year == 2018]
t2 <- p$data[year == 2030]

t1[, `:=`(pop2030 = t2$pop, ages2 = ageband)]

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
                      headline = "{f(x)} vs {f(y)}", 
                      .name = "headline3",  
                      f = scales::number_format(big.mark = ","))


para_text <- glue::glue("{HSCPval} populations in the  ",
                        "65-74, 75-84, and 85+ agebands will increase by ",
                        chart_text$headline2[4],
                        ", ",
                        chart_text$headline2[5],
                        " and ",
                        chart_text$headline2[6],
                        " respectively.")

p <- p + ggtitle(label = para_text)
print(p)
