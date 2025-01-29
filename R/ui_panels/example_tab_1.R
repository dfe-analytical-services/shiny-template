example_tab_1_panel <- function() {
  tabPanel(
    "Example tab 1",
    gov_main_layout(
      gov_row(
        column(
          width = 12,
          id = "main_col",
          h1("Overall content title for this dashboard page"),
        ),
        # Inputs section --------------------------------------------------
        column(
          width = 12,
          gov_box(
            column(
              width = 5,
              selectizeInput(
                "selectPhase",
                "Select a school phase:",
                choices = choices_phase,
                multiple = FALSE,
                selected = "All Local authority maintained schools"
              )
            ),
            column(
              width = 5,
              selectizeInput(
                "selectArea",
                "Choose an area:",
                choices = choices_areas$area_name,
                multiple = FALSE,
                selected = "England"
              )
            ),
            # Download button -------------------------------------------
            column(
              width = 2,
              downloadButton(
                outputId = "download_data",
                label = "Download data",
                icon = shiny::icon("download"),
                class = "downloadButton"
              )
            )
          ),
        ),
        # Tabset under dropdowns ----------------------------------------------
        column(
          width = 12,
          tabsetPanel(
            id = "tabsetpanels",
            # Value boxes tab -------------------------------------------------
            tabPanel(
              "Valuebox example",
              h2("Examples of producing value boxes in R-Shiny"),
              bslib::layout_column_wrap(
                width = 1 / 2,
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
            ),
            # Timeseries tab --------------------------------------------------
            tabPanel(
              "Line chart example",
              fluidRow(
                column(
                  width = 12,
                  h2("An example line chart using ggplot and ggiraph"),
                  girafeOutput("lineRevBal", width = "100%", height = "100%")
                )
              )
            ),
            # Map tab --------------------------------------------------
            tabPanel(
              "Map example",
              h2("An example map using leaflet"),
              bslib::layout_column_wrap(
                width = 1 / 2, # Two columns of equal width
                # heights_equal = "none",  # Disable equal column heights
                leafletOutput("mapOut"),
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
                      "selectBenchLAs",
                      "Select benchmark local authorities",
                      choices = choices_las$area_name,
                      multiple = TRUE,
                      options = list(maxItems = 3)
                    )
                  ),
                  h2("An Example Reactable"),
                  reactableOutput("tabBenchmark2")
                )
              )
            )
          )
        )
      )
    )
  )
}
