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

  reactive_map_labels <- reactive({
    quantile_num <- 5
    probs <- seq(0, 1, length.out = quantile_num + 1)
    bins <- quantile(reactive_map_dataset()$PC_schools_with_deficit, probs, na.rm = TRUE, names = FALSE)
    bins <- unique(bins)

    pal <- colorBin("YlOrRd", bins = bins)

    bins_dset <- as.data.frame(bins) %>%
      mutate(lower_lim = lag(bins, 1)) %>%
      dplyr::filter(!is.na(lower_lim)) %>%
      mutate(label = paste0(lower_lim, " - ", bins)) %>%
      rowwise() %>%
      mutate(colour = pal(lower_lim))

    return(bins_dset)
  })

  reactive_map_to_display <- reactive({
    leaflet(reactive_map_dataset()) %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
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
        colors = paste0(
          reactive_map_labels()$colour,
          "; width: 15px; height: 15px; border:1px solid black; border-radius: square"
        ),
        labels = paste0(reactive_map_labels()$label),
        title = "% Schools with Deficit",
        opacity = 1
      )
  })

  # Table for map chart
  output$tableMap <- renderReactable({
    reactable(
      reactive_map_dataset() %>%
        sf::st_drop_geometry() %>%
        select(
          Area = area_name,
          `% Schools with deficit` = PC_schools_with_deficit
        ),
      defaultPageSize = 7,
      searchable = TRUE,
      filterable = TRUE,
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

  # Download Map data

  output$download_map_button_ui <- renderUI({
    shinyGovstyle::download_button(
      "download_Map",
      "Download Map Data",
      file_type = substr(
        input$file_type_Map,
        1,
        unlist(gregexpr(" ", input$file_type_Map))[1] - 1
      ),
      file_size = substr(
        input$file_type_Map,
        nchar(input$file_type_Map) - 7,
        nchar(input$file_type_Map) - 1
      )
    )
  })

  output$download_Map <- downloadHandler(
    filename = function(name) {
      raw_name <- "map_raw_data"
      extension <- if (input$file_type_Map == "CSV (Up to 5.47 MB)") {
        ".csv"
      } else {
        ".xlsx"
      }
      paste0(tolower(gsub(" ", "", raw_name)), extension)
    },
    ## Generate downloaded file ---------------------------------------------
    content = function(file) {
      if (input$file_type_Map == "CSV (Up to 5.47 MB)") {
        write.csv(reactive_map_dataset() %>% sf::st_drop_geometry(), file)
      } else {
        pop_up <- showNotification("Generating download file", duration = NULL)
        openxlsx::write.xlsx(reactive_map_dataset() %>% sf::st_drop_geometry(), file, colWidths = "Auto")
        on.exit(removeNotification(pop_up), add = TRUE)
      }
    }
  )
  # Dataset with benchmark data -----------------------------------------------
  reactive_benchmark <- reactive({
    df_revbal %>%
      filter(
        area_name %in% c(
          input$selectArea,
          input$selectBenchLAs1,
          input$selectBenchLAs2
        ),
        school_phase == input$selectPhase,
        year == max(year)
      )
  })

  observe({
    updateSelectizeInput(session,
      "selectBenchLAs2",
      choices = c("", choices_las$area_name[choices_las$area_name != input$selectBenchLAs1]),
      selected = isolate(input$selectBenchLAs2)
    )
  })

  observe({
    updateSelectizeInput(session,
      "selectBenchLAs1",
      choices = c("", choices_las$area_name[choices_las$area_name != input$selectBenchLAs2]),
      selected = isolate(input$selectBenchLAs1)
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

  output$download_chart_button_ui <- renderUI({
    shinyGovstyle::download_button(
      "download_RevBal",
      "Download Chart Data",
      file_type = substr(
        input$file_type_RevBal,
        1,
        unlist(gregexpr(" ", input$file_type_RevBal))[1] - 1
      ),
      file_size = substr(
        input$file_type_RevBal,
        nchar(input$file_type_RevBal) - 7,
        nchar(input$file_type_RevBal) - 1
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
            card(ggiraph::girafeOutput("rev_line_chart", width = "100%", height = "100%"),
              role = "img",
              `aria-label` = "Line chart showing average revenue balance by region"
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

  # Table for revenue balance chart
  output$tableRevBal <- renderReactable({
    reactable(
      reactive_rev_bal() %>%
        select(
          `Time Period` = time_period,
          `Geographic Level` = geographic_level,
          Area = area_name,
          `School Phase` = school_phase,
          `Number of School` = number_schools,
          `Average Revenue Balance  (£)` = average_revenue_balance
        ),
      defaultPageSize = 7,
      searchable = TRUE,
      filterable = TRUE,
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

  # Data download revenue balance table
  output$download_RevBal <- downloadHandler(
    filename = function(name) {
      raw_name <- paste0("line_chart_data_download_", Sys.Date())
      extension <- if (input$file_type_RevBal == "CSV (Up to 5.47 MB)") {
        ".csv"
      } else if (input$file_type_RevBal == "XLSX (Up to 1.75 MB)") {
        ".xlsx"
      } else {
        ".jpeg"
      }
      paste0(raw_name, extension)
    },
    ## Generate downloaded file ---------------------------------------------
    content = function(file) {
      if (input$file_type_RevBal == "CSV (Up to 5.47 MB)") {
        write.csv(reactive_rev_bal(), file)
      } else if (input$file_type_RevBal == "XLSX (Up to 1.75 MB)") {
        # Added a basic pop up notification as the Excel file can take time to generate
        pop_up <- showNotification("Generating download file", duration = NULL)
        openxlsx::write.xlsx(reactive_rev_bal(), file, colWidths = "Auto")
        on.exit(removeNotification(pop_up), add = TRUE)
      } else {
        file.copy(
          ggplot2::ggsave(
            filename = tempfile(paste0("line_chart_download_", Sys.Date(), ".jpeg")),
            plot = line_chart_basic(), device = "jpeg"
          ),
          file
        )
      }
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

  # navigation link within text --------------------------------------------
  observeEvent(input$nav_link, {
    shiny::updateTabsetPanel(session, "navlistPanel", selected = input$nav_link)
  })

  # Dynamic label showing custom selections -----------------------------------
  output$dropdown_label <- renderText({
    paste0("Current selections: ", input$selectPhase, ", ", input$selectArea)
  })

  # footer links -----------------------
  shiny::observeEvent(input$accessibility_statement, {
    shiny::updateTabsetPanel(session, "navlistPanel", selected = "a11y_panel")
  })

  shiny::observeEvent(input$use_of_cookies, {
    shiny::updateTabsetPanel(session, "navlistPanel", selected = "cookies_panel_ui")
  })

  shiny::observeEvent(input$support_and_feedback, {
    shiny::updateTabsetPanel(session, "navlistPanel", selected = "support_panel_ui")
  })

  shiny::observeEvent(input$privacy_notice, {
    showModal(modalDialog(
      external_link("https://www.gov.uk/government/organisations/department-for-education/about/personal-information-charter", # nolint
        "Privacy notice",
        add_warning = FALSE
      ),
      easyClose = TRUE,
      footer = NULL
    ))

    # JavaScript to auto-click the link and close the modal
    shinyjs::runjs("
      setTimeout(function() {
        var link = document.querySelector('.modal a');
        if (link) {
          link.click();
          setTimeout(function() {
            $('.modal').modal('hide');
          }, 20); // Extra delay to avoid any race conditions
        }
      }, 400);
    ")
  })

  shiny::observeEvent(input$external_link, {
    showModal(modalDialog(
      external_link("https://shiny.posit.co/",
        "External Link",
        add_warning = FALSE
      ),
      easyClose = TRUE,
      footer = NULL
    ))

    # JavaScript to auto-click the link and close the modal
    shinyjs::runjs("
      setTimeout(function() {
        var link = document.querySelector('.modal a');
        if (link) {
          link.click();
          setTimeout(function() {
            $('.modal').modal('hide');
          }, 20); // Extra delay to avoid any race conditions
        }
      }, 400);
    ")
  })

  # Stop app ------------------------------------------------------------------
  session$onSessionEnded(function() {
    stopApp()
  })
}
