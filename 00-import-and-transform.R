library(here)
library(readxl)
library(data.table)
library(stringr)
library(purrr)

here <- here::here()

source(here("funs", "import_data.R"))
source(here("funs", "transformDT.R"))

files <- c("sape-2021-males",
           "sape-2021-females",
           "sape-2021-persons")

purrr::walk(files, ~ import_data(.x))

setwd(here("gender-level"))

filename <- c("sape-2021-females-nhsh-wide.RDS",
              "sape-2021-males-nhsh-wide.RDS",
              "sape-2021-persons-nhsh-wide.RDS")
gender <-  c("female", "male", "persons")

purrr::walk2(filename, gender, ~ transformDT(.x, .y))



# now do Scotland wide, with different column names
# takes some time - do not use in live demonstration !!
#
# filename <- c("all-scotland-sape-2021-females-wide.RDS",
#               "all-scotland-sape-2021-males-wide.RDS",
#               "all-scotland-sape-2021-persons-wide.RDS")
#
#
# names_to_keep <- c( "Data_zone_code", "Data_zone_name",
#                     "Council_area_code", "Council_area_name",
#                     "gender_level","Total_population")
#
# purrr::walk2(filename, gender, transformDT,
#              names_to_keep = c( "Data_zone_code", "Data_zone_name",
#                                 "Council_area_code", "Council_area_name",
#                                 "gender_level","Total_population"))

