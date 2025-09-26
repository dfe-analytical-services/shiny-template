example_tab_1_panel <- function() {
  bslib::nav_panel(
    "example_tab_1",
    gov_main_layout(
      gov_row(
        column(
          width = 12,
          id = "main_col",
          h1("Overall content title for this dashboard page")
        ),
        # Inputs section --------------------------------------------------
        layout_column_wrap(
          width = 0.5,
          selectizeInput(
            "selectPhase",
            "Select a school phase:",
            choices = choices_phase,
            multiple = FALSE,
            selected = "All Local authority maintained schools"
          ),
          selectizeInput(
            "selectArea",
            "Choose an area:",
            choices = choices_areas$area_name,
            multiple = FALSE,
            selected = "England"
          ),
          shinyGovstyle::download_button(
            "download_data",
            "Download Input Data",
            file_size = "1.4 MB"
          )
        ),
        # Tabset under dropdowns ----------------------------------------------
        column(
          width = 12,
          tabsetPanel(
            id = "tabsetpanels",
            # Value boxes tab -------------------------------------------------
            tabPanel(
              "Valuebox example",
              h2("This panel shows how to present data using a chart / table /
                 download tabset alongside some example value boxes."),
              bslib::layout_columns(
                col_widths = bslib::breakpoints(md = c(12, 12), lg = c(8, 4)),
                create_output_tabs(
                  "line_chart_example",
                  chart_output = {
                    h2("An example line chart using ggplot and ggiraph")
                    uiOutput("lineRevBalUI")
                  },
                  table_output = reactableOutput("tableRevBal"),
                  download_output = {
                    list(
                      radioButtons(
                        inputId = "file_type_RevBal",
                        label = "Choose download file format",
                        choices = c("CSV (Up to 5.47 MB)", "XLSX (Up to 1.75 MB)", "JPEG (Up to 153 KB)"),
                        selected = "CSV (Up to 5.47 MB)"
                      ),
                      uiOutput("download_chart_button_ui")
                    )
                  }
                ),
                div(
                  style = "display: flex; flex-direction: column; gap: 1rem;",
                  br(),
                  bslib::value_box(
                    title = "Average revenue balance",
                    value = textOutput("average_revenue_balance"),
                    theme = value_box_theme(bg = "#1d70b8")
                  ),
                  bslib::value_box(
                    title = "Change from previous year",
                    value = textOutput("balance_change"),
                    theme = value_box_theme(bg = "#1d70b8")
                  )
                )
              )
            ),
            # Map tab --------------------------------------------------
            tabPanel(
              "Map example",
              h2("An example map using leaflet"),
              bslib::layout_column_wrap(
                width = 1 / 2, # Two columns of equal width
                create_output_tabs(
                  "map_example",
                  chart_output = {
                    leafletOutput(
                      "mapOut"
                    )
                  },
                  table_output = reactableOutput("tableMap"),
                  download_output = {
                    list(
                      radioButtons(
                        inputId = "file_type_Map",
                        label = "Choose download file format",
                        choices = c("CSV (Up to 5.47 MB)", "XLSX (Up to 1.75 MB)"),
                        selected = "CSV (Up to 5.47 MB)"
                      ),
                      uiOutput("download_map_button_ui")
                    )
                  }
                ),
                div(
                  class = "well dynamic-height",
                  style = "min-height: auto; height: auto; overflow-y: visible;",
                  selectizeInput(
                    "selectMapYear",
                    "Select Year",
                    choices = df_revbal_years,
                    multiple = FALSE,
                    selected = max(df_revbal_years)
                  ),
                  selectizeInput(
                    "selectMapPhase",
                    "Select School Phase",
                    choices = choices_phase,
                    multiple = FALSE,
                    selected = "All Local authority maintained schools"
                  )
                )
              )
            ),
            # Benchmarking tab ------------------------------------------------
            tabPanel(
              "Benchmarking example",
              h2("An example bar chart using ggplot and ggiraph"),
              p("This is the standard paragraph style for adding guiding info around data content."),
              fluidRow(
                column(
                  width = 6, # First column for the bar chart
                  girafeOutput(
                    "colBenchmark",
                    width = "100%",
                    height = "100%"
                  )
                ),
                column(
                  width = 6, # Second column for the input and table
                  div(
                    class = "well",
                    style = "min-height: auto;
                             height: auto;
                             overflow-y: visible;
                             margin-bottom: 10px;", # Adjusted margin
                    selectizeInput(
                      "selectBenchLAs1",
                      "Select benchmark local authorities (1)",
                      choices = c("", choices_las$area_name),
                      multiple = FALSE,
                      selected = NULL
                    ),
                    selectizeInput(
                      "selectBenchLAs2",
                      "Select benchmark local authorities (2)",
                      choices = c("", choices_las$area_name),
                      multiple = FALSE,
                      selected = NULL
                    )
                  ),
                  h2("An Example Reactable"),
                  reactableOutput("tabBenchmark2")
                )
              )
            ),
            # Link in text tab ------------------------------------------------
            tabPanel(
              "Link examples",
              h2("An example of links within text"),
              p(
                "This is a link to the ",
                in_line_nav_link("support panel", "support_panel_ui"),
                " internal tab"
              ),
              shinyGovstyle::noti_banner(
                inputId = "banner",
                title_txt = "Example Notification Banner",
                body_txt = "Example body text"
              ),
              warning_text(
                "warn1",
                "A warning here - something bad will happen"
              ),
              shiny::tags$p(
                "An external link to ", external_link("https://shiny.posit.co/", "R Shiny"), " which is great."
              )
            )
          )
        )
      )
    )
  )
}
