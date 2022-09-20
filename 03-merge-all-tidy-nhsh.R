library(data.table)
library(dplyr)
library(here)

here <- here::here()

setwd(here("gender-level", "tidy"))


males <- readRDS("sape-2021-males-nhsh-tidy.RDS")

females  <- readRDS("sape-2021-females-nhsh-tidy.RDS")

persons <- readRDS("sape-2021-persons-nhsh-tidy.RDS")

l <- list(males, females,persons)

DT <- rbindlist(l, idcol = FALSE)


DT[!is.na(age_band),
   pop_age_band := fcase(
     variable == 0, "< 1",
     variable %in% c(1:4), "1-4",
     variable %in% c(5:9), "5-9",
     variable %in% c(10:14), "10-14",
     variable %in% c(15:19), "15-19",
     variable %in% c(20:24), "20-24",
     variable %in% c(25:29), "25-29",
     variable %in% c(30:34), "30-34",
     variable %in% c(35:39), "35-39",
     variable %in% c(40:44), "40-44",
     variable %in% c(45:49), "45-49",
     variable %in% c(50:54), "50-54",
     variable %in% c(55:59), "55-59",
     variable %in% c(60:64), "60-64",
     variable %in% c(65:69), "65-69",
     variable %in% c(70:74), "70-74",
     variable %in% c(75:79), "75-79",
     variable %in% c(80:84), "80-84",
     variable %in% c(85:89), "85-89",
     variable == 90, "90+",
     default = NA_character_  )]

age_levels <- unique(DT$pop_age_band)

DT[, pop_age_band := factor(pop_age_band,
                            levels = age_levels,
                            ordered = TRUE)][]



saveRDS(DT,here("gender-level", "tidy","main-nhsh-combined_2021.RDS"))
