# ---------------------------------------------------------
# This is the global file.
# Use it to store functions, library calls, source files etc.
# Moving these out of the server file and into here improves performance
# The global file is run only once when the app launches and stays consistent across users
# whereas the server and UI files are constantly interacting and responsive to user input.
#
# ---------------------------------------------------------


# Library calls ---------------------------------------------------------------------------------
shhh <- suppressPackageStartupMessages # It's a library, so shhh!
shhh(library(shiny))
shhh(library(shinyjs))
shhh(library(tools))
shhh(library(testthat))
shhh(library(shinytest))
shhh(library(shinydashboard))
shhh(library(shinyWidgets))
shhh(library(shinyGovstyle))
shhh(library(dplyr))
shhh(library(ggplot2))
shhh(library(plotly))
shhh(library(DT))
shhh(library(xfun))

# Functions ---------------------------------------------------------------------------------

# Here's an example function for simplifying the code needed to commas separate numbers:

# cs_num ----------------------------------------------------------------------------
# Comma separating function

cs_num <- function(value) {
  format(value, big.mark = ",", trim = TRUE)
}

# tidy_code_function -------------------------------------------------------------------------------
# Code to tidy up the scripts.

tidy_code_function <- function() {
  message("----------------------------------------")
  message("App scripts")
  message("----------------------------------------")
  app_scripts <- eval(styler::style_dir(recursive = FALSE)$changed)
  message("Test scripts")
  message("----------------------------------------")
  test_scripts <- eval(styler::style_dir("tests/", filetype = "r")$changed)
  script_changes <- c(app_scripts, test_scripts)
  return(script_changes)
}

# Source scripts ---------------------------------------------------------------------------------

# Source any scripts here. Scripts may be needed to process data before it gets to the server file.
# It's best to do this here instead of the server file, to improve performance.

# source("R/filename.r")


# appLoadingCSS ----------------------------------------------------------------------------
# Set up loading screen

appLoadingCSS <- "
#loading-content {
  position: absolute;
  background: #000000;
  opacity: 0.9;
  z-index: 100;
  left: 0;
  right: 0;
  height: 100%;
  text-align: center;
  color: #FFFFFF;
}
"

site_primary    <- "https://department-for-education.shinyapps.io/dfe-shiny-template/"
site_overflow   <- "https://department-for-education.shinyapps.io/dfe-shiny-template-overflow/"
sites_list <- c(site_primary, site_overflow, site_overflow)
ees_pub_name    <- "Pupil Attendance in Schools publication"
ees_publication <- "https://explore-education-statistics.service.gov.uk/find-statistics/pupil-attendance-in-schools"

source("R/support_links.R")
source("R/read_data.R")

# Read in the data
dfRevBal <- read_revenue_data()
# Get geographical levels from data
dfAreas <- dfRevBal %>%
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
  rbind(dfAreas %>% filter(geographic_level == "Regional") %>% select(geographic_level, area_name = region_name)) %>%
  rbind(choicesLAs)

choicesYears <- unique(dfRevBal$time_period)

choicesPhase <- unique(dfRevBal$school_phase)

# disconnect duck ---------------------------------------------------------

customDisconnectMessage <- function(refresh = "Refresh page",
                                    links = sites_list,
                                    publication_name=ees_pub_name,
                                    publication_link=ees_publication) {
  checkmate::assert_string(refresh)

  htmltools::tagList(
    htmltools::tags$script(
      paste0(
        "$(function() {",
        "  $(document).on('shiny:disconnected', function(event) {",
        "    $('#custom-disconnect-dialog').show();",
        "    $('#ss-overlay').show();",
        "  })",
        "});"
      )
    ),
    htmltools::tags$div(
      id = "custom-disconnect-dialog",
      style = "display: none !important;",
      htmltools::tags$div(
        id = "ss-connect-refresh",
        tags$p("You've lost connection to the dashboard server - please try refreshing the page:"),
        tags$p(tags$a(id = "ss-reload-link", 
                      href = "#", "Refresh page",
                      onclick = "window.location.reload(true);")),
        if(length(links)>1){
          tags$p("If this persists, you can also view the dashboard at one of our mirror sites:",
          tags$p(
            tags$a(href = links[1], "Site 1"),
            " - ",
            tags$a(href = links[2], "Site 2"),
            if(length(links==3)){"-"},
            if(length(links==3)){tags$a(href = links[3], "Site 3")}
          )
      )
          },
        if(!is.null(publication_name)){
        tags$p("All the data used in this dashboard can also be viewed or downloaded via the ",
               tags$a(href=publication_link,
                      publication_name),
               "on Explore Education Statistics."
        )},
        tags$p("Please contact",
               tags$a(href="mailto:statistics.development@education.gov.uk","statistics.development@education.gov.uk"),
               "with details of any problems with this resource.")
        #  ),
        # htmltools::tags$p("If this persists, you can view tables and data via the ",htmltools::tags$a(href ='https://explore-education-statistics.service.gov.uk/find-statistics/pupil-attendance-in-schools', "Pupil attendance in schools")," release on Explore Education Statistics and please contact statistics.development@education.gov.uk with details of what you were trying to do.")
      )
    ),
    htmltools::tags$div(id = "ss-overlay", style = "display: none;"),
    htmltools::tags$head(htmltools::tags$style(
      glue::glue(
        .open = "{{", .close = "}}",
        "#custom-disconnect-dialog a {
             display: {{ if (refresh == '') 'none' else 'inline' }} !important;
             color: #1d70b8 !important;
             font-size: 16px !important;
             font-weight: normal !important;
          }"
      )
    )
  )
  )
}


