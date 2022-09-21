
#' transformDT
#'
#'transform source data from wide to long, rename columns and create new summary variables
#'
#' wide to long with data.table::melt
#'
#' remove 'Age_' from column names
#' ensure variable is numeric and create age_band summary column
#'
#'
#' @param filename
#' @param gender
#' @param names_to_keep
#'
#' @return
#' @export
#'
#' @examples
#'
#'
transformDT <- function(filename = "sape-2021-males-nhsh-wide.RDS",
                        gender = "male",
                        names_to_keep = c("DataZone",
                                          "SubHSCPName",
                                          "Data_zone_code",
                                          "Data_zone_name",
                                          "Council_area_code",
                                          "Council_area_name",
                                          "gender_level",
                                          "Total_population")) {
  here <- here::here()
  setwd(here("gender-level"))

  .DT <- data.table::setDT(readRDS(filename))


  if (gender != "persons") {

    .DT <- .DT[, !c("Sex")]
  }

  .DT[,`:=`(gender_level = ..gender)][]
  .DT_tidy <- data.table::melt(.DT, id.vars = names_to_keep)
  .DT_tidy[, variable := gsub("Age_", "", variable)][]
  .DT_tidy[variable == '90_and_over', variable := 90][]
  .DT_tidy[,variable := as.numeric(variable)][]
  .DT_tidy[variable %in% c(0:90),
           age_band := data.table::fcase(
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
