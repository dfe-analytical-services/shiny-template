homepage_panel <- function() {
  tabPanel(
    "Homepage",
    fluidPage(
      fluidRow(
        column(
          12,
          h1("DfE Analytical Services R-Shiny data dashboard template"),
          p("This app demonstrates the DfE Analytical Services R-Shiny data dashboard template."),
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
                style = "color: white;font-size: 18px;font-style: bold; background-color: #1d70b8;",
                h2("Contents")
              ),
              div(
                class = "panel-body",
                tags$div(
                  title = "This section is useful if you want to understand how well different industries retain graduates.",
                  h3(actionLink("link_to_app_content_tab", "App Content"))
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
                style = "color: white;font-size: 18px;font-style: bold; background-color: #1d70b8;",
                h2("Background Info")
              ),
              div(
                class = "panel-body",
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
    fluidRow(
      fluidRow(
        width=12,
        h2("Inputs"),
        column(width=6,
        selectizeInput("selectPhase",
                    "Select a school phase",
                    choices = choicesPhase
                    )
        ),
        column(
          width=6,
          selectizeInput(
            inputId = "selectArea",
            label = "Choose an area:",
            choices = choicesAreas$area_name
          )
        )
      ),
      fluidRow(width=12,
          h2("Outputs"),
          valueBoxOutput("boxavgRevBal", width = 6),
          valueBoxOutput("boxpcRevBal", width = 6),
          plotOutput("lineRevBal"),
        br()
        # add box to show user input
      )
    )
  )
}