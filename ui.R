# -----------------------------------------------------------------------------
# This is the ui file. Use it to call elements created in your server file into
# the app, and define where they are placed, and define any user inputs.
#
# Other elements like charts, navigation bars etc. are completely up to you to
# decide what goes in. However, every element should meet accessibility
# requirements and user needs.
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# The documentation for GOV.UK components can be found at:
#
#    https://github.com/moj-analytical-services/shinyGovstyle
#
# -----------------------------------------------------------------------------
ui <- function(input, output, session) {
  bslib::page_fluid(
    # Set application metadata ------------------------------------------------
    tags$head(HTML("<title>Department for Education (DfE) Shiny Template</title>")),
    tags$head(tags$link(rel = "shortcut icon", href = "dfefavicon.png")),
    use_shiny_title(),
    tags$html(lang = "en"),
    # Add meta description for search engines
    meta() %>%
      meta_general(
        application_name = "Department for Education (DfE) Shiny Template",
        description = "Department for Education (DfE) Shiny Template",
        robots = "index,follow",
        generator = "R-Shiny",
        subject = "stats development",
        rating = "General",
        referrer = "no-referrer"
      ),

    # Custom disconnect function ----------------------------------------------
    # Variables used here are set in the global.R file
    dfeshiny::custom_disconnect_message(
      links = sites_list,
      publication_name = parent_pub_name,
      publication_link = parent_publication
    ),

    # Load javascript dependencies --------------------------------------------
    shinyjs::useShinyjs(),

    # Cookies -----------------------------------------------------------------
    # Setting up cookie consent based on a cookie recording the consent:
    dfeshiny::dfe_cookies_script(),
    dfeshiny::cookies_banner_ui(
      name = "Department for Education (DfE) Shiny Template"
    ),

    # Skip_to_main -------------------------------------------------------------
    # Add a 'Skip to main content' link for keyboard users to bypass navigation.
    # It stays hidden unless focussed via tabbing.
    shinyGovstyle::skip_to_main(),

    # Google analytics --------------------------------------------------------
    tags$head(includeHTML(("google-analytics.html"))),
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "dfe_shiny_gov_style.css"
      )
    ),
    tags$head(
      tags$style(HTML("
  .govuk-main-wrapper,
  .govuk-width-container,
  .main-content,
  .bslib-grid,
  .layout-column-wrap {
    margin-top: 5px !important;
    padding-top: 0px !important;
  }
"))
    ),

    # Header ------------------------------------------------------------------
    dfeshiny::header(
      header = "Department for Education (DfE) Shiny Template"
    ),

    # Beta banner -------------------------------------------------------------
    shinyGovstyle::banner(
      "beta banner",
      "Beta",
      "This dashboard is in beta phase and we are still reviewing performance and reliability."
    ),
    gov_main_layout(
      bslib::navset_hidden(
        id = "navlistPanel",
        nav_panel(
          "dashboard",
          ## Main dashboard ---------------------------------------------------
          layout_columns(
            # Override default wrapping breakpoints to avoid text overlap
            col_widths = breakpoints(sm = c(4, 8), md = c(3, 9), lg = c(2, 9)),
            ## Left navigation ------------------------------------------------
            dfe_contents_links(
              links_list =
                c(
                  "Example tab 1" = "example_tab_1",
                  "User guide" = "user_guide",
                  "Accessibility" = "a11y_panel",
                  "Cookies" = "cookies_panel_ui",
                  "Support and feedback" = "support_panel_ui"
                )
            ),
            ## Dashboard panels -----------------------------------------------
            bslib::navset_hidden(
              id = "left_nav",
              example_tab_1_panel(),
              user_guide_panel(),
              bslib::nav_panel(
                "a11y_panel",
                dfeshiny::a11y_panel(
                  dashboard_title = site_title,
                  dashboard_url = site_primary,
                  date_tested = "12th March 2024",
                  date_prepared = "1st July 2024",
                  date_reviewed = "1st July 2024",
                  issues_contact = "explore.statistics@education.gov.uk",
                  non_accessible_components = c("List non-accessible components here"),
                  specific_issues = c("List specific issues here")
                )
              ),
              bslib::nav_panel(
                "cookies_panel_ui",
                cookies_panel_ui(google_analytics_key = google_analytics_key)
              ),
              bslib::nav_panel(
                "support_panel_ui",
                support_panel(
                  team_email = "explore.statistics@education.gov.uk",
                  repo_name = "https://github.com/dfe-analytical-services/shiny-template",
                  form_url = "https://forms.office.com"
                )
              )
            )
          )
        ),
        ## Footer pages -------------------------------------------------------
        shinyGovstyle::footer(
          full = TRUE,
          links = c(
            "Accessibility statement",
            "Use of cookies",
            "Support and feedback",
            "Privacy notice",
            "External link"
          )
        )
      )
    )
  )
}
