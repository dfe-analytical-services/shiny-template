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
        # Expandable section --------------------------------------------------
        column(
          width = 12,
          expandable(
            input_id = "details", label = textOutput("dropdown_label"),
            contents =
              div(
                id = "div_a",
                # User selection dropdowns ------------------------------------
                gov_row(
                  column(
                    width = 6,
                    shinyGovstyle::select_Input(
                      inputId = "selectPhase",
                      label = "Select a school phase",
                      select_text = choices_phase,
                      select_value = choices_phase
                    )
                  ),
                  column(
                    width = 6,
                    shinyGovstyle::select_Input(
                      inputId = "selectArea",
                      label = "Choose an area:",
                      select_text = choices_areas$area_name,
                      select_value = choices_areas$area_name
                    )
                  ),
                  # Download button -------------------------------------------
                  column(
                    width = 12,
                    paste("Download the underlying data for this dashboard:"),
                    br(),
                    downloadButton(
                      outputId = "download_data",
                      label = "Download data",
                      icon = shiny::icon("download"),
                      class = "downloadButton"
                    )
                  )
                )
              )
          ),
        ),
        # Tabset under dropdowns ----------------------------------------------
        column(
          width = 12,
          tabsetPanel(
            id = "tabsetpanels",
            # valuebox tab ------------------------------------------------
            tabPanel(
              "Valuebox example",
              fluidRow(
                column(
                  width = 6,
                  create_output_tabs(
                    chart_output = {
                      h2("An example line chart using ggplot and ggiraph")
                      girafeOutput("lineRevBal", width = "100%", height = "100%")
                    },
                    table_output = reactableOutput("tableRevBal"),
                    download_output = {
                      list(
                        radioButtons(
                          inputId = "file_type_RevBal",
                          label = "Choose download file format",
                          choices = c("CSV (Up to 5.47 MB)", "XLSX (Up to 1.75 MB)"),
                          selected = "CSV (Up to 5.47 MB)"
                        ),
                        downloadButton(
                          outputId = "download_RevBal",
                          label = "Download data",
                          icon = shiny::icon("download"),
                          class = "downloadButton"
                        )
                      )
                    }
                  )
                ),
                column(
                  br(),
                  br(),
                  br(),
                  width = 6,
                  fluidRow(
                    valueBoxOutput("box_balance_latest", width = 6)
                  ),
                  fluidRow(
                    valueBoxOutput("box_balance_change", width = 6)
                  )
                )
              )
            ),
            # Map tab --------------------------------------------------
            tabPanel(
              "Map example",
              fluidRow(
                # map output here ---------------------------------------
                column(
                  width = 6,
                  create_output_tabs(
                    chart_output = {
                      h2("An example map using leaflet")
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
                        downloadButton(
                          outputId = "download_Map",
                          label = "Download data",
                          icon = shiny::icon("download"),
                          class = "downloadButton"
                        )
                      )
                    }
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
