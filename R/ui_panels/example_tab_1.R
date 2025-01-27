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
                bslib::layout_column_wrap(
                  width = 1 / 2, # Each item takes 50% width
                  gap = "10px", # Adjust spacing between rows and columns
                  shinyGovstyle::select_Input(
                    inputId = "selectPhase",
                    label = "Select a school phase",
                    select_text = choices_phase,
                    select_value = choices_phase
                  ),
                  shinyGovstyle::select_Input(
                    inputId = "selectArea",
                    label = "Choose an area:",
                    select_text = choices_areas$area_name,
                    select_value = choices_areas$area_name
                  ),
                  # Full-width button on a new row
                  bslib::layout_column_wrap(
                    width = 1, # Full width for the button
                    div(
                      paste("Download the underlying data for this dashboard:"),
                      br(),
                      downloadButton(
                        outputId = "download_data",
                        label = "Download data",
                        icon = shiny::icon("download"),
                        class = "downloadButton",
                        style = "background-color: white; color: black; border: 1px solid #ddd;"
                      )
                    )
                  )
                )
              )
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
              bslib::layout_column_wrap(
                width = 1 / 2, # Two equal-width columns for the bar chart and the inputs
                heights_equal = "row",
                girafeOutput(
                  "colBenchmark",
                  width = "100%",
                  height = "100%"
                ),
                bslib::layout_column_wrap(
                  width = 1, # Single-column layout for the input and table
                  div(
                    class = "well", # Add dynamic-height for the well panel
                    style = "min-height: auto; height: auto; overflow-y: visible;",
                    selectizeInput(
                      "selectBenchLAs",
                      "Select benchmark local authorities",
                      choices = choices_las$area_name,
                      multiple = TRUE,
                      options = list(maxItems = 3)
                    )
                  ),
                  h2("An example Reactable"),
                  reactableOutput(
                    "tabBenchmark2"
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
