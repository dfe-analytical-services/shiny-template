#!/usr/bin/env Rscript

# make sure that R/sysdata.rda is not out of date

error_flag <- FALSE

datalog  <- "datafiles_log.csv"
files    <- read.csv(datalog)
suffixes <- c("xlsx","dat","csv","tex","pdf")


# data.frame(files=list.files("./",recursive = TRUE)) %>% filter(grepl(files))

# if ( file.mtime(nounfile) > file.mtime(sysdatafile) ){
#   cat("Error:", nounfile, "is newer than", sysdatafile, "\n")
#   error_flag <- TRUE
# }


if ( error_flag ){
  cat("Run 'make' in the ./data-raw directory\n")
  quit(save = "no", status = 1, runLast = FALSE)
}