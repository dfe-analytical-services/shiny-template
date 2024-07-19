homepage_panel <- function() {
  tabPanel(
    "User guide and information",
    gov_main_layout(
      gov_row(
        column(
          12,
          h1("Department for Education (DfE) Analytical Services R-Shiny data dashboard template"),
          br(),
          br()
        ),

        ## Left panel -------------------------------------------------------

        column(
          6,
          div(
            div(
              class = "panel panel-info",
              div(
                class = "panel-heading",
                style = "color: white;font-size: 18px;font-style: bold;
                background-color: #1d70b8;",
                h2("Contents")
              ),
              div(
                class = "panel-body",
                tags$div(
                  h3("Introduction"),
                  p("This app demonstrates the DfE Analytical Services R-Shiny
                    data dashboard template."),
                  p("You might want to add some brief introductory text here
                    alongside some links to different tabs within your
                    dashboard. Here's an example of a link working:"),
                  p(actionLink("link_to_app_content_tab", "Dashboard panel")),
                  p("You need to add an observeEvent() function to the server.R
                    script for any link that navigates within your App.")
                ),
                br()
              )
            )
          ),
        ),

        ## Right panel ------------------------------------------------------

        column(
          6,
          div(
            div(
              class = "panel panel-info",
              div(
                class = "panel-heading",
                style = "color: white;font-size: 18px;font-style: bold;
                background-color: #1d70b8;",
                h2("Background Info")
              ),
              div(
                class = "panel-body",
                h3("Context and purpose"),
                p("This app is the DfE Analytical Service's R-Shiny template
                  demonstration app and is being developed to provide a coherent
                  styling for DfE dashboards alongside some useful example
                  componenets that teams can adapt for their own uses."),
                p("DfE teams using this template should avoid changing the
                  styling and layout, keeping the header, footer and side
                  navigation list formats."),
                p("You might want to add some relevant background information
                  for your users here. For example some useful links to your
                  Explore Education Statistics (EES)
                  publication, data sources and other relevant resources."),
                h3("Guidance sources"),
                p("For example, here we'll add some of the key resources we draw
                  on to guide styling and vizualisation...")
              )
            )
          )
        )
      )
    )
  )
}


dashboard_panel <- function() {
  tabPanel(
    value = "dashboard",
    "Dashboard",

    # Define UI for application that draws a histogram

    # Sidebar with a slider input for number of bins
    gov_main_layout(
      gov_row(
        column(
          width = 12,
          h1("Overall content title for this dashboard page"),
        ),
        column(
          width = 12,
          expandable(
            input_id = "details", label = textOutput("dropdown_label"),
            contents =
              div(
                id = "div_a",
                gov_row(
                  column(
                    width = 6,
                    selectizeInput("selectPhase",
                      "Select a school phase",
                      choices = choices_phase
                    )
                  ),
                  column(
                    width = 6,
                    selectizeInput(
                      inputId = "selectArea",
                      label = "Choose an area:",
                      choices = choices_areas$area_name
                    )
                  ),
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
        column(
          width = 12,
          tabsetPanel(
            id = "tabsetpanels",
            tabPanel(
              "Valuebox example",
              fluidRow(
                column(
                  width = 12,
                  h2("Examples of producing value boxes in R-Shiny"),
                  fluidRow(
                    column(
                      width = 12,
                      valueBoxOutput("boxavgRevBal_small", width = 6),
                      valueBoxOutput("boxpcRevBal_small", width = 6)
                    )
                  ),
                  fluidRow(
                    column(
                      width = 12,
                      valueBoxOutput("boxavgRevBal", width = 6),
                      valueBoxOutput("boxpcRevBal", width = 6)
                    )
                  ),
                  fluidRow(
                    column(
                      width = 12,
                      valueBoxOutput("boxavgRevBal_large", width = 6),
                      valueBoxOutput("boxpcRevBal_large", width = 6)
                    )
                  )
                )
              )
            ),
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
            tabPanel(
              "Benchmarking example",
              fluidRow(
                column(
                  width = 12,
                  h2("An example bar chart using ggplot and ggiraph"),
                  p("This is the standard paragraph style for adding guiding
                    info around data content."),
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
                    dataTableOutput("tabBenchmark")
                  )
                )
              )
            )
          )
        )
        # add box to show user input
      )
    )
  )
}
