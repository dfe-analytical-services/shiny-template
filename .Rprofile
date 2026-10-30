# ---------------------------------------------------------
# This is the .Rprofile file
#
# Use it to include any functions you want to run before any other code is run.
# For example, using renv automatically sources its activate script to the .RProfile file
# This ensures that all renv checks on package versions happens before any code is run.
#
# ---------------------------------------------------------

message("Sourcing .Rprofile...")

# Posit Connect manages its own package library and does not bundle the renv/
# folder or (necessarily) install renv, so only run development set-up locally.
on_connect <- Sys.getenv("R_CONFIG_ACTIVE") == "rsconnect" ||
  Sys.getenv("RSTUDIO_PRODUCT") == "CONNECT"

if (!on_connect) {
  if (file.exists("renv/activate.R")) {
    source("renv/activate.R")
  }

  if (requireNamespace("renv", quietly = TRUE)) {
    renv::status()
  }

  if (system.file(package = "dfeshiny") != "") {
    library(dfeshiny)
  } else {
    warning(
      "dfeshiny package is not installed, please run renv::restore() to set up the necessary package environment"
    )
  }

  # Install commit-hooks locally
  if (dir.exists(".git/hooks")) {
    statusWriteCommit <- file.copy(
      ".hooks/pre-commit.R",
      ".git/hooks/pre-commit",
      overwrite = TRUE
    )
  }
}

rm(on_connect)
