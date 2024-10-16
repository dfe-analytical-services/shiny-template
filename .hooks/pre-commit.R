#!/usr/bin/env Rscript
cat("Running commit hooks...", fill = TRUE)
shhh <- suppressPackageStartupMessages # It's a library, so shhh!
shhh(library(dplyr))
shhh(library(xfun))
shhh(library(dfeshiny))

message("\n")

message("1. Checking for unpublished data...\n")

error_flag <- FALSE

datalog <- "datafiles_log.csv"
log_files <- read.csv(datalog, stringsAsFactors = FALSE)
ign_files <- read.csv(".gitignore", header = FALSE, stringsAsFactors = FALSE)
colnames(ign_files)[1] <- "filename"

message("Contents of the .gitignore file:")
print(ign_files)

# Run a pass through the .gitignore files and look for any issues
if (ncol(ign_files) > 1) {
  message("ERROR: It looks like you've got commas in the .gitignore. Please correct the .gitignore file and try again.")
  error_flag <- TRUE
} else {
  for (i in 1:nrow(ign_files)) {
    if (grepl(" ", ign_files$filename[i])) {
      message("ERROR: It looks like you've got spaces in filenames in the .gitignore. Please rename your files if they contain spaces and update the .gitignore file accordingly.")
      error_flag <- TRUE
    }
  }
}

suffixes <- "xlsx$|ods$|dat$|csv$|tex$|pdf$|zip$|gz$|parquet$|rda$|rds$"

current_files <- data.frame(files = list.files("./", recursive = TRUE)) %>%
  filter(grepl(suffixes, files, ignore.case = TRUE), !grepl("renv|datafiles_log.csv", files))

for (file in current_files$files) {
  if (!file %in% log_files$filename) {
    message("Error: ", file, " is not recorded in datafiles_log.csv.\n\n")
    message("Please add an entry to datafiles_log.csv for this file and mark it as unpublished, published or reference.\n\n")
    error_flag <- TRUE
  } else {
    file_status <- (log_files %>% filter(filename == file))$status
    if (!file_status %in% c("published", "Published", "reference", "Reference", "dummy", "Dummy")) {
      if (!file %in% ign_files$filename & !grepl("unpublished", file)) {
        message("Error: ", file, " is not logged as published or reference data in datafiles_log.csv and is not found in .gitignore.\n\n")
        message("If the file contains published or reference data then update its entry in datafiles_log.csv.\n\n")
        message("If the file contains unpublished data then add it to the .gitignore file.\n\n")
        error_flag <- TRUE
      } else {
        message(file, " is recorded in the logfile as unpublished data and in .gitignore and so will not be included as part of the commit.\n\n")
      }
    }
  }
}


if (error_flag) {
  message("Warning, aborting commit. Unrecognised data files found, please update .gitignore or datafiles_log.csv.\n")
  quit(save = "no", status = 1, runLast = FALSE)
} else {
  message("...all good!")
}

message("\n")

message("2. Checking Google Analytics tag...\n")

if (grepl("G-Z967JJVQQX", htmltools::includeHTML(("google-analytics.html"))) &
  !(toupper(Sys.getenv("USERNAME")) %in% c("CFOSTER4", "CRACE", "LSELBY", "RBIELBY", "JMACHIN"))) {
  message("...cleaning out the template's Google Analytics tag.")
  gsub_file("google-analytics.html", pattern = "G-Z967JJVQQX", replacement = "G-XXXXXXXXXX")
  gsub_file("ui.R", pattern = "Z967JJVQQX", replacement = "XXXXXXXXXX")
  system2(command = "git", args = c("add", "google-analytics.html"))
} else {
  message("...all good!")
}

message("\n")

message("3. Checking code styling...\n")
style_output <- eval(styler::style_dir()$changed)
if (any(style_output)) {
  message("Warning: Code failed styling checks.
  \n`styler::style_dir()` has been run for you.
  \nPlease check your files and dashboard still work.
  \nThen re-stage and try committing again.")
  quit(save = "no", status = 1, runLast = FALSE)
} else {
  message("...code styling checks passed")
  message("\n")
}

# End of hooks
