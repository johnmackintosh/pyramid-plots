
#' import_data
#'
#' @param sourcefile partial name of source spreadsheet used to import data and
#'  create final filenames
#'
#' @return writes dataframes out to disk
#' @export
#'
#' @examples
#'
#' import_data("sape-2021-males")
#'
#'
import_data <- function(sourcefile) {

  here <- here::here()


  s_sheet <- paste0(sourcefile, ".xlsx") # spreadsheet name

  path_in <- here("source_data",s_sheet) # fully qualified name

  outfile1 <- paste0(sourcefile,"-nhsh-wide.RDS") # write out files to these locations
  outfile2 <- paste0("all-scotland-",sourcefile,"-wide.RDS")


  data_in <- readxl::read_excel(here(path_in),
                                sheet = 2,
                                skip = 2)

  DT <- data.table::setDT(data.table::copy(data_in))

  # need to remove spaces within the column names
  oldnames <- names(DT) # original column names
  newnames <- stringr::str_replace_all(oldnames," ", "_")
  data.table::setnames(DT, old =  oldnames, new = newnames)

  # lookup and bring in HSCP names
  DZ2 <- data.table::fread(here::here("lookups","datazones_HSCP_lookup_with_joincol.csv"))
  nhsh <- DT[Council_area_name %in% c("Argyll and Bute", "Highland")][, joinvar := Data_zone_code][]
  nhsh <- DZ2[nhsh, on = "joinvar"][, joinvar := NULL]

  # write out to disk
  saveRDS(nhsh, here("gender-level",outfile1))
  saveRDS(DT,here("gender-level", outfile2))

}
