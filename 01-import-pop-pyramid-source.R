# Imports data from the source male, female and persons spreadsheets, filters to NHSH areas,
# joins with other geography data and saves in wide format format for future processing

# saves data for males, females and persons
# also saves scotland level data for each gender for further processing

# source data
# spreadsheets to be downloaded from


#UPDATED
# https://www.nrscotland.gov.uk/files//statistics/population-estimates/sape-time-series/persons/sape-2021-persons.xlsx
#https://www.nrscotland.gov.uk/files//statistics/population-estimates/sape-time-series/males/sape-2021-males.xlsx
# https://www.nrscotland.gov.uk/files//statistics/population-estimates/sape-time-series/females/sape-2021-females.xlsx





library(here)
library(readxl)
library(data.table)
library(stringr)
library(purrr)


here <- here::here()
source(here("funs", "import_data.R"))

files <- c("sape-2021-males", "sape-2021-females", "sape-2021-persons")
purrr::walk(files, ~ import_data(.x))







