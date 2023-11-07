# ---------------------------------------------------------
# This is the .Rprofile file
#
# Use it to include any functions you want to run before any other code is run.
# For example, using renv automatically sources its activate script to the .RProfile file
# This ensures that all renv checks on package versions happens before any code is run.
#
#
# ---------------------------------------------------------

cat("Sourcing .Rprofile.", fill = TRUE)

source("renv/activate.R")

if (system.file(package = "dfeshiny") != "") {
  library(dfeshiny)
} else {
  warning("dfeshiny package is not installed, please run renv::restore() to set up the necessary package environment")
}

# Function to run tests
run_tests_locally <- function() {
  Sys.unsetenv("http_proxy")
  Sys.unsetenv("https_proxy")
  source("global.r")
  # message("================================================================================")
  # message("== testthat ====================================================================")
  # message("")
  # testthat::test_dir("tests/testthat")
  # message("")
  message("================================================================================")
  message("== shinytest2 ==================================================================")
  message("")
  shinytest2::test_app()
  message("")
  message("================================================================================")
}

# Install commit-hooks locally
statusWriteCommit <- file.copy(".hooks/pre-commit.R", ".git/hooks/pre-commit", overwrite = TRUE)
