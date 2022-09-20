# plot per HSCP

output_plot <- function(hscp,
                        extension = ".png",
                        nbreaks = 8,
                        w = 4,
                        h = 5,
                        print_plot = FALSE,
                        save_plot = TRUE) {


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

  tempdf <- collapse::fsubset(pyramid_tots, SubHSCPName ==  hscp)

  plotfilename <- paste0(tempdf$SubHSCPName[[1]], "-", "pyramid-plot", ".", extension)
  titletext <- paste0("Population structure of ", tempdf$SubHSCP[[1]], ", 2022")

  stitle <- paste0(hscp, " by age band and gender")

  chart_caption = "Data source: NRS Small Area Population Estimates (SAPE) 2020"

  p <- ggplot(tempdf,aes(pop_age_band, pop_age_band_total, fill = gender_level)) +
    geom_col(data = tempdf[gender_level == "female"]) +
    geom_col(data = tempdf[gender_level == "male"]) +
    scale_fill_manual("", values = c("male" = lightblue,
                                     'female' = plot_grey),
                      labels = c("Male", "Female")) +
    scale_y_continuous(breaks = pretty(tempdf$pop_age_band_total, n = nbreaks),
                       labels = abs(pretty(tempdf$pop_age_band_total, n = nbreaks))) +
    coord_flip() +
    chart_opts +
    labs(title = titletext,
         subtitle = stitle,
         caption = chart_caption,
         x = xlabs,
         y = ylabs)

  if (print_plot) {
    print(p)
  }

  if (save_plot) {
    ggsave(
      filename = plotfilename,
      device = extension,
      width = w,
      height = h)
  }

}


# plot individual files for future use

hscp <- collapse::funique(pyramid_tots$SubHSCPName)

safe_output_plot <- purrr::safely(output_plot)
output_dir <- file.path(here::here(), "img", "pyramid-plots")
if (!dir.exists(output_dir)) {dir.create(output_dir)}
setwd(output_dir)

purrr::walk(hscp, safe_output_plot, extension = "png")
