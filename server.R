# ---------------------------------------------------------
# This is the server file.
# Use it to create interactive elements like tables, charts and text for your app.
#
# Anything you create in the server file won't appear in your app until you call it in the UI file.
# This server script gives an example of a plot and value box that updates on slider input.
# There are many other elements you can add in too, and you can play around with their reactivity.
# The "outputs" section of the shiny cheatsheet has a few examples of render calls you can use:
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

  # Loading screen ---------------------------------------------------------------------------
  # Call initial loading screen

  hide(id = "loading-content", anim = TRUE, animType = "fade")
  show("app-content")

  # Simple server stuff goes here ------------------------------------------------------------
  reactiveRevBal <- reactive({
    dfRevBal %>% filter(area_name == input$selectArea | area_name=='England',
                        school_phase == input$selectPhase)
  })

  # Define server logic required to draw a histogram
  output$lineRevBal <- renderPlot({
    createAvgRevTimeSeries(reactiveRevBal(),input$selectArea)
  })

  # Define server logic to create a box

  output$boxavgRevBal <- renderValueBox({

    # Put value into box to plug into app
    valueBox(
      # take input number
      paste0('£',format((reactiveRevBal() %>% filter(year==max(year),
                                 area_name==input$selectArea,
                                 school_phase==input$selectPhase))$average_revenue_balance,
             big.mark=',')),
      # add subtitle to explain what it's hsowing
      paste0("This is the latest value for the selected inputs"),
      color = "blue"
    )
  })
  output$boxpcRevBal <- renderValueBox({
    
    # Put value into box to plug into app
    valueBox(
      # take input number
      input$selectPhase,
      # add subtitle to explain what it's hsowing
      paste0("This is the selected phase"),
      color = "blue"
    )
  })
  
  observeEvent(input$link_to_app_content_tab, {
    updateTabsetPanel(session, "navbar", selected = "app_content")
  })


  # Stop app ---------------------------------------------------------------------------------

  session$onSessionEnded(function() {
    stopApp()
  })
}
