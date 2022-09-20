facet_pyramid_percent <- function(df = pyramid_percent_tots,
                          council = NULL,
                          facet_cols = 2,
                          ax_limits = "fixed",
                          nbreaks = 8,
                          ...) {

  chart_title <- 'Population structure of Highland Community Partnerships, 2021'
  chart_caption = "Data source: NRS Small Area Population Estimates (SAPE) 2021"


  chart_opts <- theme_minimal(base_size = 10) +
    theme(legend.position = "bottom") +
    theme(plot.title = element_text(size = 14)) +
    theme(plot.title = element_text(hjust = 0)) +
    ggExtra::removeGridY()

  # x and y labels
  xlabs <- "Age band"
  ylabs = "Population"

  darkblue <- '#092869'    #NHS SCOTLAND DARK BLUE
  lightblue <- '#0391BF'   #NHS SCOTLAND LIGHT BLUE

  plot_grey <- "grey70"


  temp_council <- deparse(substitute(council))


  localities <-  eval(substitute(alist(...)), envir = parent.frame())
  localities <- sapply(as.list(localities), deparse)


  # filter for council if necessary
  if (temp_council != "NULL") {
    tempdf <- df[Council_area_name == temp_council]
  } else {
    tempdf <- df
  }

  # then filter for HSCPs

  if (length(localities)) {
    tempdf <- tempdf[SubHSCPName %in% localities]
  }

  if (temp_council != "NULL") {
    stitle <- paste0(temp_council, " area", " by age band and gender")
  } else {
    stitle <- "All areas by age band and gender"
  }

  max_per <- max(tempdf$percent_of_tot, na.rm = TRUE)
  min_per <- min(tempdf$percent_of_tot, na.rm = TRUE)



  p <- ggplot(tempdf,aes(pop_age_band,percent_of_tot, fill = gender_level)) +
    geom_col(data = tempdf[gender_level == "female"]) +
    geom_col(data = tempdf[gender_level == "male"]) +
    scale_fill_manual("", values = c("male" = lightblue,
                                     'female' = 'grey70'),
                      labels = c("Male", "Female")) +
    facet_wrap( ~ SubHSCPName, ncol = facet_cols) +

    # scale_y_continuous(breaks = pretty(pyramid_percent_tots$percent_of_tot, n = 10),
    #                    labels = paste0(abs(pretty(pyramid_percent_tots$percent_of_tot, n = 10)),"%")) +

    scale_y_continuous( limits = c(min_per, max_per),
                        breaks = seq(from = floor(min_per),
                                     to = ceiling(max_per),
                                     by = 1),
                        labels = paste0(abs(seq(from = floor(min_per),
                                                to = ceiling(max_per),
                                                by = 1)), "%"))  +

    coord_flip() +
    chart_opts +
    labs(title = chart_title,
         caption = chart_caption,
         subtitle = NULL,
         x = xlabs,
         y = "Percent of HSCP Population")


  print(p)

}
