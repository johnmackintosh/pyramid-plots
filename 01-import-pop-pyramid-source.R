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



files <- c("sape-2021-males", "sape-2021-females", "sape-2021-persons")

import_data <- function(sourcefile) {

here <- here::here()


s_sheet <- paste0(sourcefile, ".xlsx") # spreadsheet name

path_in <- here("source_data",s_sheet) # fully qualified name

outfile1 <- paste0(sourcefile,"-nhsh-wide.RDS") # write out files to these locations
outfile2 <- paste0("all-scotland-",sourcefile,"-wide.RDS")


data_in <- read_excel(here(path_in),
                      sheet = 2,
                      skip = 2)

DT <- setDT(copy(data_in))

# need to remove spaces within the colum names
oldnames <- names(DT) # original column names
newnames <- stringr::str_replace_all(oldnames," ", "_")
setnames(DT, old =  oldnames, new = newnames)

# lookup and bring in HSCP names
DZ2 <- fread(here::here("lookups","datazones_HSCP_lookup_with_joincol.csv"))
nhsh <- DT[Council_area_name %in% c("Argyll and Bute", "Highland")][, joinvar := Data_zone_code][]
nhsh <- DZ2[nhsh, on = "joinvar"][, joinvar := NULL]

# write out to disk
saveRDS(nhsh, here("gender-level",outfile1))
saveRDS(DT,here("gender-level", outfile2))

}


library(here)
library(readxl)
library(data.table)
library(dplyr)
library(purrr)

here <- here::here()
purrr::walk(files, ~ import_data(.x))







