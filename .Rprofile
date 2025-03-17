# ---------------------------------------------------------
# This is the .Rprofile file
#
# Use it to include any functions you want to run before any other code is run.
# For example, using renv automatically sources its activate script to the .RProfile file
# This ensures that all renv checks on package versions happens before any code is run.
#
# ---------------------------------------------------------

message("Sourcing .Rprofile...")

source("renv/activate.R")

if (system.file(package = "dfeshiny") != "") {
  library(dfeshiny)
} else {
  warning(
    "dfeshiny package is not installed, please run renv::restore() to set up the necessary package environment"
  )
}

# Install commit-hooks locally
statusWriteCommit <- file.copy(
  ".hooks/pre-commit.R",
  ".git/hooks/pre-commit",
  overwrite = TRUE
)

# Check for air and settings - need package data.table to do this
if (system.file(package = "data.table") != "") {
  library(data.table)
} else {
  install.packages("data.table")
  library(data.table)
}

if ("air" %in% system("ls ~/.config/.", intern = TRUE)) {
  print("installed")
} else {
  print("air not installed: installing now")
  system <- Sys.info()[1]
  if (system == "Windows") {
    system(
      'powershell -ExecutionPolicy Bypass -c "irm https://github.com/posit-dev/air/releases/latest/download/air-installer.ps1 | iex"'
    )
  } else {
    system(
      "curl -LsSf https://github.com/posit-dev/air/releases/latest/download/air-installer.sh | sh"
    )
  }
}

configs <- readLines("~/.config/rstudio/rstudio-prefs.json")
changes <- 0

if (
  any(
    configs %like%
      '"code_formatter_external_command": "~/.local/bin/air format"'
  )
) {
  print("referenced")
} else {
  print("not referenced")
  new_line <- '"code_formatter_external_command": "~/.local/bin/air format",'
  configs <- append(configs, new_line, after = 1)
  changes <- changes + 1
}
if (any(configs %like% '"reformat_on_save": true')) {
  print("active")
} else {
  print("not active: activating now")
  new_line <- '"reformat_on_save": true,'
  configs <- append(configs, new_line, after = 1)
  changes <- changes + 1
}
if (any(configs %like% '"code_formatter": "external"')) {
  print("external ref")
} else {
  print("no external ref: ref now")
  new_line <- '"code_formatter": "external",'
  configs <- append(configs, new_line, after = 1)
  changes <- changes + 1
}
if (changes > 0) {
  writeLines(configs, "~/.config/rstudio/rstudio-prefs.json")
}
