# -----------------------------------------------------------------------------
# This is the global file.
#
# Use it to store functions, library calls, source files etc.
#
# Moving these out of the server file and into here improves performance as the
# global file is run only once when the app launches and stays consistent
# across users whereas the server and UI files are constantly interacting and
# responsive to user input.
#
# Library calls ---------------------------------------------------------------
shhh <- suppressPackageStartupMessages # It's a library, so shhh!

# Core shiny and R packages
shhh(library(shiny))
shhh(library(bslib))
shhh(library(rstudioapi))

# Custom packages
shhh(library(dfeR))
shhh(library(dfeshiny))
shhh(library(shinyGovstyle))

# Creating charts and tables
shhh(library(ggplot2))
shhh(library(DT))

# Data and string manipulation
shhh(library(dplyr))
shhh(library(stringr))
shhh(library(ggiraph))

# Shiny extensions
shhh(library(shinyjs))
shhh(library(tools))
shhh(library(shinydashboard))
shhh(library(shinyWidgets))
shhh(library(shinytitle))
shhh(library(xfun))
shhh(library(metathis))
shhh(library(shinyalert))

# Dependencies needed for testing or CI but not for the app -------------------
# Including them here keeps them in renv but avoids the app needlessly loading
# them, saving on load time.
if (FALSE) {
  shhh(library(shinytest2))
  shhh(library(testthat))
}

# Source scripts --------------------------------------------------------------

# Source any scripts here. Scripts may be needed to process data before it gets
# to the server file or to hold custom functions to keep the main files shorter
#
# It's best to do this here instead of the server file, to improve performance.

# Source script for loading in data
source("R/read_data.R")

# Source custom functions script
source("R/helper_functions.R")

# Source all files in the ui_panels folder
lapply(list.files("R/ui_panels/", full.names = TRUE), source)

# Set global variables --------------------------------------------------------

site_title <- "Department for Education (DfE) Shiny Template" # name of app
parent_pub_name <- "Statistical publication" # name of source publication
parent_publication <- # link to source publication
  "https://explore-education-statistics.service.gov.uk/find-statistics/apprenticeships"

# Set the URLs that the site will be published to
site_primary <- "https://department-for-education.shinyapps.io/dfe-shiny-template/"
site_overflow <- "https://department-for-education.shinyapps.io/dfe-shiny-template-overflow/"

# Combine URLs into list for disconnect function
# We can add further mirrors where necessary. Each one can generally handle
# about 2,500 users simultaneously
sites_list <- c(site_primary, site_overflow)

# Set the key for Google Analytics tracking
google_analytics_key <- "Z967JJVQQX"

# End of global variables -----------------------------------------------------

# Enable bookmarking so that input choices are shown in the url ---------------
enableBookmarking("url")

# Read in the data ------------------------------------------------------------
df_revbal <- read_revenue_data()

# Get geographical areas from data
df_areas <- df_revbal %>%
  select(
    geographic_level, country_name, country_code,
    region_name, region_code,
    la_name, old_la_code, new_la_code
  ) %>%
  distinct()

# Extract lists for use in drop downs -----------------------------------------
# LA list
choices_las <- df_areas %>%
  filter(geographic_level == "Local authority") %>%
  select(geographic_level, area_name = la_name) %>%
  arrange(area_name)

# Full list of areas
choices_areas <- df_areas %>%
  filter(geographic_level == "National") %>%
  select(geographic_level, area_name = country_name) %>%
  rbind(
    df_areas %>%
      filter(geographic_level == "Regional") %>%
      select(geographic_level, area_name = region_name)
  ) %>%
  rbind(choices_las)

# List of phases
choices_phase <- unique(df_revbal$school_phase)
