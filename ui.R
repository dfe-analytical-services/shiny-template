# ---------------------------------------------------------
# This is the ui file.
# Use it to call elements created in your server file into the app, and define
# where they are placed. Also use this file to define inputs.
#
# Every UI file should contain:
# - A title for the app
# - A call to a CSS file to define the styling
# - An accessibility statement
# - Contact information
#
# Other elements like charts, navigation bars etc. are completely up to you to
# decide what goes in. However, every element should meet accessibility
# requirements and user needs.
#
# This file uses a slider input, but other inputs are available like date
# selections, multiple choice dropdowns etc. Use the shiny cheatsheet to explore
# more options: https://shiny.rstudio.com/images/shiny-cheatsheet.pdf
#
# Likewise, this template uses the navbar layout.
# We have used this as it meets accessibility requirements, but you are free to
# use another layout if it does too.
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# ---------------------------------------------------------

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# The documentation for this GOVUK components can be found at:
#
#    https://github.com/moj-analytical-services/shinyGovstyle
#


#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# The documentation for this GOVUK components can be found at:
#
#    https://github.com/moj-analytical-services/shinyGovstyle
#

ui <- function(input, output, session) {
  fluidPage(
    # use_tota11y(),
    title = tags$head(
      tags$link(
        rel = "shortcut icon",
        href = "dfefavicon.png"
      ),
      # Add title for browser tabs
      tags$title("DfE Shiny Template")
    ),
    use_shiny_title(),
    tags$html(lang = "en"),
    # Add meta description for search engines
    meta() %>%
      meta_general(
        application_name = "DfE Shiny Template",
        description = "DfE Shiny Template",
        robots = "index,follow",
        generator = "R-Shiny",
        subject = "stats development",
        rating = "General",
        referrer = "no-referrer"
      ),
    shinyjs::useShinyjs(),
    customDisconnectMessage(),
    useShinydashboard(),
    # Setting up cookie consent based on a cookie recording the consent:
    # https://book.javascript-for-r.com/shiny-cookies.html
    tags$head(
      tags$script(
        src = paste0(
          "https://cdn.jsdelivr.net/npm/js-cookie@rc/",
          "dist/js.cookie.min.js"
        )
      ),
      tags$script(src = "cookie-consent.js")
    ),
    tags$head(includeHTML(("google-analytics.html"))),
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "dfe_shiny_gov_style.css"
      )
    ),
    shinyGovstyle::cookieBanner("DfE R-Shiny dashboard template"),
    shinyGovstyle::header(
      main_text = "",
      main_link = "https://www.gov.uk/government/organisations/department-for-education",
      secondary_text = "DfE Shiny Template",
      logo = "images/DfE_logo_landscape.png",
      logo_width = 150,
      logo_height = 32
    ),
    shinyGovstyle::banner(
      "beta banner",
      "beta",
      paste0(
        "This Dashboard is in beta phase and we are still reviewing performance
        and reliability. ",
        "In case of slowdown or connection issues due to high demand, we have
        produced two instances of this site which can be accessed at the
        following links: ",
        "<a href=", site_primary, " id='link_site_1'>Site 1</a> and ",
        "<a href=", site_overflow, " id='link_site_2'>Site 2</a>."
      )
    ),
    shiny::navlistPanel(
      "",
      id = "navlistPanel",
      widths = c(2, 8),
      well = FALSE,
      dashboard_panel(),
      homepage_panel(),
      a11y_panel(),
      support_panel(
        team_email = "statistics.development@education.gov.uk",
        repo_name = "https://github.com/dfe-analytical-services/shiny-template",
        form_url = "https://forms.office.com"
      )
    ),
    tags$script(
      src = "script.js"
    ),
    footer(full = TRUE)
  )
}
