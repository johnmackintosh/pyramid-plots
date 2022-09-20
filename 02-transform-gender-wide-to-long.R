library(here)
library(readxl)
library(data.table)
library(dplyr)
library(purrr)

# transform data to long

here <- here::here()

### globals and functions ###

transformDT <- function(filename = "sape-2021-males-nhsh-wide.RDS",
                        gender = "male",
                        names_to_keep = c("DataZone",
                                          "SubHSCPName",
                                          "Data_zone_code",
                                          "Data_zone_name",
                                          "Council_area_code",
                                          "Council_area_name",
                                          "gender_level")) {
  here <- here::here()

  setwd(here("gender-level"))

  names_to_persist <- names_to_keep


  .DT <- setDT(readRDS(filename))


  if (gender == "persons") {

    .DT <- .DT[, !c("Total_population")]
  }


  if (gender != "persons") {

  .DT <- .DT[, !c("Sex", "Total_population")]
  }



  .DT[,`:=`(gender_level = ..gender)][]
  .DT_tidy <- melt(.DT, id.vars = names_to_persist)
  .DT_tidy[, variable := gsub("Age_", "", variable)][]
  .DT_tidy[variable %in% c(0,1,2,3,4,5,6,7,8,9), variable := paste0(0,variable, sep = "")][]
  .DT_tidy[variable == '90_and_over', variable := 90][]
  .DT_tidy[,variable := as.numeric(variable)][]
  .DT_tidy[variable %in% c(0:90), age_band := fcase(
    variable %in% c(0:15), "0-15",
    variable %in% c(16:29), "16-29",
    variable %in% c(30:44), "30-44",
    variable %in% c(45:59), "45-59",
    variable %in% c(60:74), "60-74",
    variable %in% c(75:84), "75-84",
    variable >= 85, "85+",
    default = NA_character_
  )][]


  newfile <- gsub("wide","tidy",filename)
  setwd(here)
  saveRDS(.DT_tidy, here("gender-level","tidy", newfile))

}

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

