library(data.table)
library(dplyr)
library(collapse)
library(here)
library(ggplot2)

# globals

here <- here::here()

setwd(here("gender-level", "tidy"))

# this dataset has both the 7 level age band and the 20 level population plot age band

main <- readRDS(here("gender-level", "tidy","main-nhsh-combined_2021.RDS"))

#persons <- main[gender_level == "persons"]


pyramid_tots <- main[!is.na(age_band),
                     .(pop_age_band_total = sum(value)),
                     .(gender_level,SubHSCPName, pop_age_band, Council_area_name)
]



pyramid_tots[gender_level == "male", pop_age_band_total := pop_age_band_total * -1][]


age_band_tots <-  main[!is.na(age_band),
                       .(age_band_total = sum(value)),
                       .(gender_level,SubHSCPName, age_band, Council_area_name)][]



# use persons to get the grand totals
# these are the GRAND TOTAL Populations by SUBHSCP
population_totals <-  main[gender_level == "persons" & !is.na(age_band),
                           .(total_pop = sum(value)),
                           .(SubHSCPName, Council_area_name)]

# the gender level totals by SUBHSCP
# might need these to recreate Figure 2 of CP Profile
gender_level_pop_totals <- main[!is.na(age_band),
                                .(gender_total_pop = sum(value)),
                                .(SubHSCPName, Council_area_name, gender_level)]

saveRDS(gender_level_pop_totals,
        here("gender-level","tidy","nhsh-subhscp-gender-level-pop-totals.RDS"))

#join and calculate percent for population pyramids

pyramid_percent_tots <- population_totals[pyramid_tots, on = c("SubHSCPName", "Council_area_name")
][,percent_of_tot := (abs(pop_age_band_total) / total_pop) * 100
][]

# negate the percentage for males so it goes to left of zero on plot
# use abs() to undo this in any other calculations
pyramid_percent_tots[gender_level == "male", percent_of_tot := percent_of_tot * -1]



# now repeat for the higher level age bandings

age_band_percent_tots <- population_totals[age_band_tots, on = c("SubHSCPName", "Council_area_name")
][,percent_of_tot := (abs(age_band_total) / total_pop) * 100][]

age_band_percent_tots[gender_level == "male", percent_of_tot := percent_of_tot * -1]


saveRDS(pyramid_tots,here("gender-level","tidy", "pyramid_tots.RDS"))
saveRDS(pyramid_percent_tots,here("gender-level","tidy", "pyramid_percent_tots.RDS"))

saveRDS(age_band_tots,here("gender-level","tidy", "age-band-tots.RDS"))
saveRDS(age_band_percent_tots,here("gender-level","tidy", "age-band-percent-tots.RDS"))


# now get percentages by gender level

pyramid_percent_gender_tots <- gender_level_pop_totals[pyramid_tots, on = c("SubHSCPName", "Council_area_name", "gender_level")
][,percent_of_gender_tot := (abs(pop_age_band_total) / gender_total_pop) * 100
][]


# Use this for figure 2 and 3
age_band_percent_gender_tots <- gender_level_pop_totals[age_band_tots, on = c("SubHSCPName", "Council_area_name", "gender_level")
][,percent_of_gender_tot := (abs(age_band_total) / gender_total_pop) * 100, .(gender_level, SubHSCPName)][]

saveRDS(age_band_percent_gender_tots,
        here("gender-level","tidy", "nhsh-age-band-percent-gender-tots.RDS"))



highland_pop_age_band  <- main[!is.na(age_band),
                               .(pop_age_band_total = sum(value)),
                               .(gender_level, pop_age_band)]

saveRDS(highland_pop_age_band,here("gender-level","tidy", "highland-pop-age-band.RDS"))

highland_age_band  <- main[!is.na(age_band),
                           .(age_band_total = sum(value)),
                           .(gender_level, age_band)]


saveRDS(highland_age_band,here("gender-level","tidy", "highland-age-band.RDS"))
