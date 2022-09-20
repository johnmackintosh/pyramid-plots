
facet_pyramid <- function(df,
                          council = NULL,
                          facet_cols = 3,
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
    #tempdf <- df[CouncilArea2019Name == temp_council]
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

  p <- ggplot(tempdf,aes(pop_age_band, pop_age_band_total, fill = gender_level)) +
    geom_col(data = tempdf[gender_level == "female"]) +
    geom_col(data = tempdf[gender_level == "male"]) +
    scale_fill_manual("", values = c("male" = lightblue,
                                     'female' = plot_grey),
                      labels = c("Male", "Female")) +
    facet_wrap( ~ SubHSCPName, ncol = facet_cols, scales = ax_limits) +
    scale_y_continuous(breaks = pretty(tempdf$pop_age_band_total, n = nbreaks),
                       labels = abs(pretty(tempdf$pop_age_band_total, n = nbreaks))) +
    coord_flip() +
    chart_opts +
    labs(title = chart_title,
         caption = chart_caption,
         subtitle = stitle,
         x = xlabs,
         y = ylabs)

  print(p)

}
