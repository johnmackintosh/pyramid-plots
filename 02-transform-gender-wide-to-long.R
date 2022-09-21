library(here)
library(readxl)
library(data.table)
library(dplyr)
library(purrr)

# transform data to long

here <- here::here()
source(here("funs", "transformDT.R"))

### globals and functions ###

### end of functions ###


filename <- c("sape-2021-females-nhsh-wide.RDS",
              "sape-2021-males-nhsh-wide.RDS",
              "sape-2021-persons-nhsh-wide.RDS")

gender <-  c("female", "male", "persons")

purrr::walk2(filename, gender, transformDT)



setwd(here("gender-level"))



# now do Scotland wide, with different column names

filename <- c("all-scotland-sape-2021-females-wide.RDS",
              "all-scotland-sape-2021-males-wide.RDS",
              "all-scotland-sape-2021-persons-wide.RDS")

gender <-  c("female", "male", "persons")

names_to_keep <- c( "Data_zone_code", "Data_zone_name",
                    "Council_area_code", "Council_area_name",
                    "gender_level")

purrr::walk2(filename, gender, transformDT,
             names_to_keep = c( "Data_zone_code", "Data_zone_name",
                              "Council_area_code", "Council_area_name",
                              "gender_level"))

