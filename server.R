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
  output$cookies_status <- dfeshiny::cookies_banner_server(
    input_cookies = shiny::reactive(input$cookies),
    parent_session = session,
    google_analytics_key = google_analytics_key
  )

  dfeshiny::cookies_panel_server(
    input_cookies = shiny::reactive(input$cookies),
    google_analytics_key = google_analytics_key
  )

  # Dataset with timeseries data ----------------------------------------------
  reactive_rev_bal <- reactive({
    df_revbal %>% filter(
      area_name == input$selectArea | area_name == "England",
      school_phase == input$selectPhase
    )
  })

  # Dataset with map data ----------------------------------------------
  reactive_map_dataset <- reactive({
    df_upper_tier_all %>%
      dplyr::filter(
        year == input$selectMapYear,
        area_name != "England",
        school_phase == input$selectMapPhase
      ) %>%
      dplyr::select(
        area_name,
        PC_schools_with_deficit,
        LONG,
        LAT,
        geometry,
        lab
      )
  })

  reactive_map_pal <- reactive({
    quantile_num <- 5
    probs <- seq(0, 1, length.out = quantile_num + 1)
    bins <- quantile(reactive_map_dataset()$PC_schools_with_deficit, probs, na.rm = TRUE, names = FALSE)
    bins <- unique(bins)

    pal <- colorBin("YlOrRd", bins = bins)
    return(pal)
  })

  reactive_map_to_display <- reactive({
    leaflet(reactive_map_dataset()) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      # addTiles() %>%
      setView(lng = -3.95, lat = 53, zoom = 5.5) %>%
      addPolygons(
        color = "black",
        fillColor = ~ reactive_map_pal()(PC_schools_with_deficit),
        fillOpacity = 0.5,
        stroke = TRUE,
        weight = 0.2,
        opacity = 0.8,
        label = ~lab
      ) %>%
      addLegend(
        # "topright",
        pal = reactive_map_pal(), values = ~PC_schools_with_deficit,
        title = "% Schools with Deficit",
        opacity = 1
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

  line_chart_basic <- reactive({
    timeseries_linechart_basic(reactive_rev_bal())
  })

  output$rev_line_chart <- renderGirafe({
    ggiraph::girafe(
      ggobj = (line_chart_basic() +
        geom_vline_interactive(
          aes(
            xintercept = year,
            tooltip = paste(year, tooltip, sep = "\n\n"),
            data_id = year,
            hover_nearest = TRUE,
            linetype = "dashed",
            color = "transparent"
          ),
          color = "transparent",
          linetype = "dashed",
          size = 3
        )),
      width_svg = 6,
      height_svg = 3,
      options = generic_ggiraph_options(
        opts_hover(
          css = "stroke-dasharray:5,5;stroke:black;stroke-width:2px;"
        ),
        opts_sizing(rescale = TRUE, width = 1.0),
        opts_toolbar(saveaspng = FALSE),
        opts_selection(
          type = "single",
          only_shiny = FALSE
        )
      )
    )
  })

  output$lineRevBalUI <- renderUI({
    div(
      style = "display: flex; justify-content: space-between; align-items: center; background: white;",
      # Line chart
      bslib::card(
        bslib::card_body(
          bslib::layout_column_wrap(
            width = NULL,
            fill = FALSE,
            style = css(grid_template_columns = "4fr 1fr"),
            card(ggiraph::girafeOutput("rev_line_chart", width = "100%", height = "100%"),
              role = "img",
              `aria-label` = "Line chart showing average revenue balance by region"
            ),
            card(
              shiny::tagAppendAttributes(
                shiny::downloadButton(
                  "download_chart",
                  label = "Download Chart",
                  icon = NULL,
                  class = "govuk-button--secondary",
                  style = "margin-left: 15px; align-self: flex-start;"
                ),
                style = "max-width: none; margin-left: 0; align-self: auto;"
              ),
              br(),
              shiny::tagAppendAttributes(
                shiny::downloadButton(
                  "download_table",
                  label = "Download Data",
                  icon = NULL,
                  class = "govuk-button--secondary",
                  style = "margin-left: 15px; align-self: flex-start;"
                ),
                style = "max-width: none; margin-left: 0; align-self: auto;"
              )
            )
          )
        ),
        full_screen = TRUE,
        style = "flex-grow: 1; display: flex; justify-content: center; padding: 0 10px;"
      )
    )
  })

  output$download_chart <- downloadHandler(
    filename = function() {
      # Use the selected dataset as the suggested file name
      paste0("line_chart_download_", Sys.Date(), ".jpeg")
    },
    content = function(file) {
      # Write the dataset to the `file` that will be downloaded
      file.copy(
        ggplot2::ggsave(
          filename = tempfile(paste0("line_chart_download_", Sys.Date(), ".jpeg")),
          plot = line_chart_basic(), device = "jpeg"
        ),
        file
      )
    }
  )

  output$download_table <- downloadHandler(
    filename = function() {
      # Use the selected dataset as the suggested file name
      paste0("line_chart_data_download_", Sys.Date(), ".csv")
    },
    content = function(con) {
      write.csv(reactive_rev_bal(), con)
    }
  )

  # Map rendering
  output$mapOut <- renderLeaflet({
    reactive_map_to_display()
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

  output$tabBenchmark2 <- renderReactable({
    reactable(
      reactive_benchmark() %>%
        select(
          Area = area_name,
          `Average Revenue Balance (£)` = average_revenue_balance,
          `Total Revenue Balance (£m)` = total_revenue_balance_million
        ),
      defaultPageSize = 4,
      minRows = 4,
      searchable = TRUE, # uncomment line if you want a search box
      filterable = TRUE, # uncomment line if you want filters at the top
      defaultSorted = list("Total Revenue Balance (£m)" = "desc"),
      defaultColDef = colDef(
        headerClass = "bar-sort-header",
        style = JS("function(rowInfo, column, state) {
      // Highlight sorted columns
      for (let i = 0; i < state.sorted.length; i++) {
        if (state.sorted[i].id === column.id) {
          return { background: 'rgba(0, 0, 0, 0.03)' }
        }
      }
    }")
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


  output$average_revenue_balance <- renderText(
    dfeR::pretty_num(latest_average_balance(), gbp = TRUE)
  )

  output$balance_change <- renderText(
    dfeR::pretty_num(
      latest_average_balance() - previous_average_balance(),
      prefix = "+/-",
      gbp = TRUE
    )
  )


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

  # Wrap a plot with a larger spinner
  with_gov_spinner <- function(ui_element, spinner_type = 6, size = 1, color = "#1d70b8") {
    shinycssloaders::withSpinner(
      ui_element,
      type = spinner_type,
      color = color,
      size = size,
      proxy.height = paste0(250 * size, "px")
    )
  }

  # Dynamic label showing custom selections -----------------------------------
  output$dropdown_label <- renderText({
    paste0("Current selections: ", input$selectPhase, ", ", input$selectArea)
  })

  # footer links -----------------------
  shiny::observeEvent(input$accessibility_statement, {
    shiny::updateTabsetPanel(session, "navlistPanel", selected = "a11y_panel")
  })

  shiny::observeEvent(input$cookies, {
    shiny::updateTabsetPanel(session, "navlistPanel", selected = "cookies_panel_ui")
  })

  shiny::observeEvent(input$support_and_feedback, {
    shiny::updateTabsetPanel(session, "navlistPanel", selected = "support_panel_ui")
  })

  # Stop app ------------------------------------------------------------------
  session$onSessionEnded(function() {
    stopApp()
  })
}
