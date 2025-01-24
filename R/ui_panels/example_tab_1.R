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
              width = 4,
              selectizeInput(
                "selectPhase",
                "Select a school phase:",
                choices = choices_phase,
                multiple = FALSE,
                selected = "All Local authority maintained schools"
              )
            ),
            column(
              width = 4,
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
              width = 4,
              h4("Download the data:", style = 'font-family: "Arial", sans-serif !important;
                   font-size: 19px;'),
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
              fluidRow(
                column(
                  width = 12,
                  h2("Examples of producing value boxes in R-Shiny"),
                  fluidRow(
                    column(
                      width = 12,
                      valueBoxOutput("box_balance_latest", width = 6),
                      valueBoxOutput("box_balance_change", width = 6)
                    )
                  )
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
              fluidRow(
                column(
                  width = 12,
                  h2("An example map using leaflet"),
                  # map output here ---------------------------------------
                  column(
                    width = 6,
                    leafletOutput(
                      "mapOut"
                    )
                  ),
                  column(
                    width = 6,
                    div(
                      class = "well",
                      style = "min-height: 100%; height: 100%; overflow-y:
                      visible",
                      fluidRow(
                        # Map dropdown selection ---------------------
                        column(
                          width = 12,
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
                    )
                  )
                )
              )
            ),
            # Benchmarking tab ------------------------------------------------
            tabPanel(
              "Benchmarking example",
              fluidRow(
                column(
                  width = 12,
                  h2("An example bar chart using ggplot and ggiraph"),
                  p("This is the standard paragraph style for adding guiding
                    info around data content."),
                  # Bar chart for benchmarking --------------------------------
                  column(
                    width = 6,
                    girafeOutput("colBenchmark",
                      width = "100%", height = "100%"
                    )
                  ),
                  column(
                    width = 6,
                    div(
                      class = "well",
                      style = "min-height: 100%; height: 100%; overflow-y:
                      visible",
                      fluidRow(
                        # Benchmarking dropdown selection ---------------------
                        column(
                          width = 12,
                          selectizeInput("selectBenchLAs",
                            "Select benchmark local authorities",
                            choices = choices_las$area_name,
                            multiple = TRUE,
                            options = list(maxItems = 3)
                          )
                        )
                      )
                    ),
                    # Benchmarking table --------------------------------------
                    h2("An example Reactable"),
                    reactableOutput("tabBenchmark2")
                  )
                )
              )
            )
          )
        )
      )
    )
  )
}
