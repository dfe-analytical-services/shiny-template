# ---------------------------------------------------------
# This is the server file.
# Use it to create interactive elements like tables, charts and text for your
# app.
#
# Anything you create in the server file won't appear in your app until you call
# it in the UI file. This server script gives an example of a plot and value box
# that updates on slider input. There are many other elements you can add in
# too, and you can play around with their reactivity. The "outputs" section of
# the shiny cheatsheet has a few examples of render calls you can use:
# https://shiny.rstudio.com/images/shiny-cheatsheet.pdf
#
#
# This is the server logic of a Shiny web application. You can run th
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# ---------------------------------------------------------
server <- function(input, output, session) {
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

  # Cookies -------------------------------------------------------------------
  # Pop up cookies banner
  output$cookie_status <- dfeshiny::cookie_banner_server(
    "cookies",
    input_cookies = reactive(input$cookies),
    parent_session = session,
    google_analytics_key = google_analytics_key,
    cookie_link_panel = "cookies_panel_ui"
  )

  # Cookies panel
  cookies_panel_server(
    id = "cookies_panel",
    input_cookies = reactive(input$cookies),
    google_analytics_key = google_analytics_key
  )

  # TODO
  # CHARTS? ----------------------------------------------
  reactive_rev_bal <- reactive({
    df_revbal %>% filter(
      area_name == input$selectArea | area_name == "England",
      school_phase == input$selectPhase
    )
  })

  # Define server logic required to draw a histogram
  output$lineRevBal <- snapshotPreprocessOutput(
    renderGirafe({
      girafe(
        ggobj = create_avg_rev_timeseries(reactive_rev_bal(), input$selectArea),
        options = list(
          opts_sizing(rescale = TRUE, width = 1.0),
          opts_toolbar(saveaspng = FALSE)
        ),
        width_svg = 9.6,
        height_svg = 5.0
      )
    }),
    function(value) {
      # Removing elements that cause issues with shinytest comparisons when run
      # on different environments
      svg_removed <- gsub(
        "svg_[0-9a-z]{8}_[0-9a-z]{4}_[0-9a-z]{4}_[0-9a-z]{4}_[0-9a-z]{12}",
        "svg_random_giraph_string", value
      )
      font_standardised <- gsub("Arial", "Helvetica", svg_removed)
      cleaned_positions <- gsub(
        "[a-z]*x[0-9]*='[0-9.]*' [a-z]*y[0-9]*='[0-9.]*'",
        "Position", font_standardised
      )
      cleaned_size <- gsub(
        "width='[0-9.]*' height='[0-9.]*'", "Size", cleaned_positions
      )
      cleaned_points <- gsub("points='[0-9., ]*'", "points", cleaned_size)
      cleaned_points
    }
  )

  reactive_benchmark <- reactive({
    df_revbal %>%
      filter(
        area_name %in% c(input$selectArea, input$selectBenchLAs),
        school_phase == input$selectPhase,
        year == max(year)
      )
  })

  output$colBenchmark <- snapshotPreprocessOutput(
    renderGirafe({
      girafe(
        ggobj = plot_avg_rev_benchmark(reactive_benchmark()),
        options = list(
          opts_sizing(rescale = TRUE, width = 1.0),
          opts_toolbar(saveaspng = FALSE)
        ),
        width_svg = 5.0,
        height_svg = 5.0
      )
    }),
    function(value) {
      # Removing elements that cause issues with shinytest comparisons when run on
      # different environments - should add to dfeshiny at some point.
      svg_removed <- gsub(
        "svg_[0-9a-z]{8}_[0-9a-z]{4}_[0-9a-z]{4}_[0-9a-z]{4}_[0-9a-z]{12}",
        "svg_random_giraph_string",
        value
      )
      font_standardised <- gsub("Arial", "Helvetica", svg_removed)
      cleaned_positions <- gsub(
        "x[0-9]*='[0-9.]*' y[0-9]*='[0-9.]*'",
        "Position", font_standardised
      )
      cleaned_size <- gsub(
        "width='[0-9.]*' height='[0-9.]*'",
        "Size", cleaned_positions
      )
      cleaned_points <- gsub("points='[0-9., ]*'", "points", cleaned_size)
      cleaned_points
    }
  )

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
        paging = FALSE
      )
    )
  })
  # Value boxes ===============================================================
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

  # Export values for use in UI tests
  exportTestValues(
    avg_rev_bal_value = latest_average_balance(),
    prev_avg_rev_bal_value = previous_average_balance()
  )

  # Export values for use in value boxes in R/ui_panels/example_tab_1.R
  output$box_balance_latest <- renderText({
    dfeR::pretty_num(latest_average_balance(), gbp = TRUE)
  })

  output$box_balance_change <- renderText({
    dfeR::pretty_num(
      latest_average_balance() - previous_average_balance(),
      prefix = "+/-",
      gbp = TRUE
    )
  })

  # ---------------------------------------------------------------------------
  # TODO: WORK OUT WHAT THIS IS
  observeEvent(input$go, {
    toggle(id = "div_a", anim = TRUE)
  })


  observeEvent(input$link_to_app_content_tab, {
    updateTabsetPanel(session, "navlistPanel", selected = "Example tab 1")
  })

  # Download the underlying data button
  output$download_data <- downloadHandler(
    filename = "shiny_template_underlying_data.csv",
    content = function(file) {
      write.csv(df_revbal, file)
    }
  )

  # Add input IDs here that are within the relevant drop down boxes to create
  # dynamic text
  output$dropdown_label <- renderText({
    paste0("Current selections: ", input$selectPhase, ", ", input$selectArea)
  })

  # Stop app ------------------------------------------------------------------
  session$onSessionEnded(function() {
    stopApp()
  })
}
