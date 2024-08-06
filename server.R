# -----------------------------------------------------------------------------
# This is the server file.
#
# Use it to create interactive elements like tables, charts and text for your
# app.
#
# Anything you create in the server file won't appear in your app until you call
# it in the UI file. This server script gives examples of plots and value boxes
#
# There are many other elements you can add in too, and you can play around with
# their reactivity. The "outputs" section of the shiny cheatsheet has a few
# examples of render calls you can use:
# https://shiny.rstudio.com/images/shiny-cheatsheet.pdf
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# -----------------------------------------------------------------------------
server <- function(input, output, session) {
  # Bookmarking ---------------------------------------------------------------
  # The template uses bookmarking to store input choices in the url. You can
  # exclude specific inputs (for example extra info created for a datatable
  # or plotly chart) using the list below, but it will need updating to match
  # any entries in your own dashboard's bookmarking url that you don't want
  # including.
  setBookmarkExclude(c(
    "cookies", "link_to_app_content_tab",
    "tabBenchmark_rows_current", "tabBenchmark_rows_all",
    "tabBenchmark_columns_selected", "tabBenchmark_cell_clicked",
    "tabBenchmark_cells_selected", "tabBenchmark_search",
    "tabBenchmark_rows_selected", "tabBenchmark_row_last_clicked",
    "tabBenchmark_state",
    "plotly_relayout-A",
    "plotly_click-A", "plotly_hover-A", "plotly_afterplot-A",
    ".clientValue-default-plotlyCrosstalkOpts"
  ))

  observe({
    # Trigger this observer every time an input changes
    reactiveValuesToList(input)
    session$doBookmark()
  })

  onBookmarked(function(url) {
    updateQueryString(url)
  })

  observe({
    if (input$navlistPanel == "Example tab 1") {
      change_window_title(
        session,
        paste0(
          site_title, " - ",
          input$selectPhase, ", ",
          input$selectArea
        )
      )
    } else {
      change_window_title(
        session,
        paste0(
          site_title, " - ",
          input$navlistPanel
        )
      )
    }
  })

  # Cookies logic -------------------------------------------------------------
  observeEvent(input$cookies, {
    if (!is.null(input$cookies)) {
      if (!("dfe_analytics" %in% names(input$cookies))) {
        shinyjs::show(id = "cookieMain")
      } else {
        shinyjs::hide(id = "cookieMain")
        msg <- list(
          name = "dfe_analytics",
          value = input$cookies$dfe_analytics
        )
        session$sendCustomMessage("analytics-consent", msg)
        if ("cookies" %in% names(input)) {
          if ("dfe_analytics" %in% names(input$cookies)) {
            if (input$cookies$dfe_analytics == "denied") {
              ga_msg <- list(name = paste0("_ga_", google_analytics_key))
              session$sendCustomMessage("cookie-remove", ga_msg)
            }
          }
        }
      }
    } else {
      shinyjs::hide(id = "cookieMain")
    }
  })

  # Need these set of observeEvent to create a path through the cookie banner
  observeEvent(input$cookieAccept, {
    msg <- list(
      name = "dfe_analytics",
      value = "granted"
    )
    session$sendCustomMessage("cookie-set", msg)
    session$sendCustomMessage("analytics-consent", msg)
    shinyjs::show(id = "cookieAcceptDiv")
    shinyjs::hide(id = "cookieMain")
  })

  observeEvent(input$cookieReject, {
    msg <- list(
      name = "dfe_analytics",
      value = "denied"
    )
    session$sendCustomMessage("cookie-set", msg)
    session$sendCustomMessage("analytics-consent", msg)
    shinyjs::show(id = "cookieRejectDiv")
    shinyjs::hide(id = "cookieMain")
  })

  observeEvent(input$hideAccept, {
    shinyjs::toggle(id = "cookieDiv")
  })

  observeEvent(input$hideReject, {
    shinyjs::toggle(id = "cookieDiv")
  })

  observeEvent(input$remove, {
    shinyjs::toggle(id = "cookieMain")
    msg <- list(name = "dfe_analytics", value = "denied")
    session$sendCustomMessage("cookie-remove", msg)
    session$sendCustomMessage("analytics-consent", msg)
    print(input$cookies)
  })

  cookies_data <- reactive({
    input$cookies
  })

  output$cookie_status <- renderText({
    cookie_text_stem <- "To better understand the reach of our dashboard tools,
    this site uses cookies to identify numbers of unique users as part of Google
    Analytics. You have chosen to"
    cookie_text_tail <- "the use of cookies on this website."
    if ("cookies" %in% names(input)) {
      if ("dfe_analytics" %in% names(input$cookies)) {
        if (input$cookies$dfe_analytics == "granted") {
          paste(cookie_text_stem, "accept", cookie_text_tail)
        } else {
          paste(cookie_text_stem, "reject", cookie_text_tail)
        }
      }
    } else {
      "Cookies consent has not been confirmed."
    }
  })

  observeEvent(input$cookieLink, {
    # Need to link here to where further info is located.  You can
    # updateTabsetPanel to have a cookie page for instance
    updateTabsetPanel(session, "navlistPanel",
      selected = "Support and feedback"
    )
  })

  # Dataset with timeseries data ----------------------------------------------
  reactive_rev_bal <- reactive({
    df_revbal %>% filter(
      area_name == input$selectArea | area_name == "England",
      school_phase == input$selectPhase
    )
  })

  # Dataset with benchmark data -----------------------------------------------
  reactive_benchmark <- reactive({
    df_revbal %>%
      filter(
        area_name %in% c(input$selectArea, input$selectBenchLAs),
        school_phase == input$selectPhase,
        year == max(year)
      )
  })

  # Charts --------------------------------------------------------------------
  # Line chart for revenue balance over time
  output$lineRevBal <- renderGirafe({
    girafe(
      ggobj = create_avg_rev_timeseries(reactive_rev_bal(), input$selectArea),
      options = list(
        opts_sizing(rescale = TRUE, width = 1.0),
        opts_toolbar(saveaspng = FALSE)
      ),
      width_svg = 9.6,
      height_svg = 5.0
    )
  })

  # Benchmarking bar chart
  output$colBenchmark <- renderGirafe({
    girafe(
      ggobj = plot_avg_rev_benchmark(reactive_benchmark()),
      options = list(
        opts_sizing(rescale = TRUE, width = 1.0),
        opts_toolbar(saveaspng = FALSE)
      ),
      width_svg = 5.0,
      height_svg = 5.0
    )
  })

  # Benchmarking table
  output$tabBenchmark <- renderDataTable({
    datatable(
      reactive_benchmark() %>%
        select(
          Area = area_name,
          `Average Revenue Balance (£)` = average_revenue_balance,
          `Total Revenue Balance (£m)` = total_revenue_balance_million
        ),
      options = list(
        scrollX = TRUE,
        paging = FALSE,
        searching = FALSE
      )
    )
  })

  # Value boxes ---------------------------------------------------------------
  # Create a reactive value for average revenue balance
  latest_average_balance <- reactive({
    reactive_rev_bal() %>%
      filter(
        year == max(year),
        area_name == input$selectArea,
        school_phase == input$selectPhase
      ) %>%
      pull(average_revenue_balance)
  })

  # Create a reactive value for previous year average
  previous_average_balance <- reactive({
    previous_year <- reactive_rev_bal() %>%
      filter(
        year == max(year) - 1,
        area_name == input$selectArea,
        school_phase == input$selectPhase
      ) %>%
      pull(average_revenue_balance)
  })

  # Export values for use in UI tests -----------------------------------------
  exportTestValues(
    avg_rev_bal_value = latest_average_balance(),
    prev_avg_rev_bal_value = previous_average_balance()
  )

  # Create a value box for average revenue balance
  output$box_balance_latest <- renderValueBox({
    value_box(
      value = dfeR::pretty_num(latest_average_balance(), gbp = TRUE),
      subtitle = paste0("Average revenue balance"),
      color = "blue"
    )
  })

  # Create a value box for the change on previous year
  output$box_balance_change <- renderValueBox({
    value_box(
      value = dfeR::pretty_num(
        latest_average_balance() - previous_average_balance(),
        prefix = "+/-",
        gbp = TRUE
      ),
      subtitle = paste0("Change from previous year"),
      color = "blue"
    )
  })

  # Link in the user guide panel back to the main panel -----------------------
  observeEvent(input$link_to_app_content_tab, {
    updateTabsetPanel(session, "navlistPanel", selected = "Example tab 1")
  })

  # Download the underlying data button --------------------------------------
  output$download_data <- downloadHandler(
    filename = "shiny_template_underlying_data.csv",
    content = function(file) {
      write.csv(df_revbal, file)
    }
  )

  # Dynamic label showing custom selections -----------------------------------
  output$dropdown_label <- renderText({
    paste0("Current selections: ", input$selectPhase, ", ", input$selectArea)
  })

  # Stop app ------------------------------------------------------------------
  session$onSessionEnded(function() {
    stopApp()
  })
}
