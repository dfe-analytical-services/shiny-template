# -----------------------------------------------------------------------------
# This is the global file.
# Use it to store functions, library calls, source files etc.
# Moving these out of the server file and into here improves performance
# The global file is run only once when the app launches and stays consistent
# across users whereas the server and UI files are constantly interacting and
# responsive to user input.
#
# Library calls ---------------------------------------------------------------
shhh <- suppressPackageStartupMessages # It's a library, so shhh!
shhh(library(shiny))
shhh(library(shinyjs))
shhh(library(tools))
shhh(library(testthat))
shhh(library(stringr))
shhh(library(shinydashboard))
shhh(library(shinyWidgets))
shhh(library(shinyGovstyle))
shhh(library(shinytitle))
shhh(library(dplyr))
shhh(library(ggplot2))
shhh(library(DT))
shhh(library(xfun))
shhh(library(metathis))
shhh(library(shinyalert))
shhh(library(shinytest2))
shhh(library(rstudioapi))
shhh(library(bslib))
shhh(library(dfeshiny))
shhh(library(ggiraph))

# Enable bookmarking so that input choices are shown in the url ---------------
enableBookmarking("url")

# Source scripts --------------------------------------------------------------

# Source any scripts here. Scripts may be needed to process data before it gets
# to the server file.
# It's best to do this here instead of the server file, to improve performance.

source("R/read_data.R")

# Set global variables --------------------------------------------------------

site_title <- "Department for Education (DfE) Shiny Template"
site_primary <- "https://department-for-education.shinyapps.io/dfe-shiny-template/"
site_overflow <- "https://department-for-education.shinyapps.io/dfe-shiny-template-overflow/"

# We can add further mirrors where necessary. Each one can generally handle
# about 2,500 users simultaneously
sites_list <- c(site_primary, site_overflow)

# Update this with your parent
# publication name (e.g. the EES publication)
ees_pub_name <- "Statistical publication"

# Update with parent publication link
ees_publication <- "https://explore-education-statistics.service.gov.uk/find-statistics/"
google_analytics_key <- "Z967JJVQQX"

# Read in the data
df_revbal <- read_revenue_data() %>%
  mutate(school_phase = case_when(
    school_phase == "All LA maintained schools" ~ "All local authority maintained schools",
    .default = school_phase
  ))

# Get geographical levels from data
dfAreas <- df_revbal %>%
  select(
    geographic_level, country_name, country_code,
    region_name, region_code,
    la_name, old_la_code, new_la_code
  ) %>%
  distinct()

choicesLAs <- dfAreas %>%
  filter(geographic_level == "Local authority") %>%
  select(geographic_level, area_name = la_name) %>%
  arrange(area_name)

choicesAreas <- dfAreas %>%
  filter(geographic_level == "National") %>%
  select(geographic_level, area_name = country_name) %>%
  rbind(
    dfAreas %>%
      filter(geographic_level == "Regional") %>%
      select(geographic_level, area_name = region_name)
  ) %>%
  rbind(choicesLAs)

choicesYears <- unique(df_revbal$time_period)

choicesPhase <- unique(df_revbal$school_phase)

expandable <- function(inputId, label, contents) {
  govDetails <- shiny::tags$details(
    class = "govuk-details", id = inputId,
    shiny::tags$summary(
      class = "govuk-details__summary",
      shiny::tags$span(
        class = "govuk-details__summary-text",
        label
      )
    ),
    shiny::tags$div(contents)
  )
}
