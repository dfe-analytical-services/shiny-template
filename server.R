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

  # output if cookie is unspecified
  observeEvent(input$cookies, {
    if (!is.null(input$cookies)) {
      if (!("dfe_analytics" %in% names(input$cookies))) {
        shinyalert(
          inputId = "cookie_consent",
          title = "Cookie consent",
          text = "This site uses cookies to record traffic flow using Google Analytics",
          size = "s",
          closeOnEsc = TRUE,
          closeOnClickOutside = FALSE,
          html = FALSE,
          type = "",
          showConfirmButton = TRUE,
          showCancelButton = TRUE,
          confirmButtonText = "Accept",
          confirmButtonCol = "#AEDEF4",
          timer = 0,
          imageUrl = "",
          animation = TRUE
        )
      } else {
        msg <- list(
          name = "dfe_analytics",
          value = input$cookies$dfe_analytics
        )
        session$sendCustomMessage("analytics-consent", msg)
        if ("cookies" %in% names(input)) {
          if ("dfe_analytics" %in% names(input$cookies)) {
            if (input$cookies$dfe_analytics == "denied") {
              ga_msg <- list(name = paste0("_ga_", google_analytics_key))
              session$sendCustomMessage("cookie-remove", ga_msg)
            }
          }
        }
      }
    }
  })

  observeEvent(input$cookie_consent, {
    msg <- list(
      name = "dfe_analytics",
      value = ifelse(input$cookie_consent, "granted", "denied")
    )
    session$sendCustomMessage("cookie-set", msg)
    session$sendCustomMessage("analytics-consent", msg)
    if ("cookies" %in% names(input)) {
      if ("dfe_analytics" %in% names(input$cookies)) {
        if (input$cookies$dfe_analytics == "denied") {
          ga_msg <- list(name = paste0("_ga_", google_analytics_key))
          session$sendCustomMessage("cookie-remove", ga_msg)
        }
      }
    }
  })

  observeEvent(input$remove, {
    msg <- list(name = "dfe_analytics", value = "denied")
    session$sendCustomMessage("cookie-remove", msg)
    session$sendCustomMessage("analytics-consent", msg)
  })

  cookies_data <- reactive({
    input$cookies
  })

  output$cookie_status <- renderText({
    cookie_text_stem <- "To better understand the reach of our dashboard tools, this site uses cookies to identify numbers of unique users as part of Google Analytics. You have chosen to"
    cookie_text_tail <- "the use of cookies on this website."
    if ("cookies" %in% names(input)) {
      if ("dfe_analytics" %in% names(input$cookies)) {
        if (input$cookies$dfe_analytics == "granted") {
          paste(cookie_text_stem, "accept", cookie_text_tail)
        } else {
          paste(cookie_text_stem, "reject", cookie_text_tail)
        }
      }
    } else {
      "Cookies consent has not been confirmed."
    }
  })


  #  output$cookie_status <- renderText(as.character(input$cookies))

  # Simple server stuff goes here ------------------------------------------------------------
  reactiveRevBal <- reactive({
    dfRevBal %>% filter(
      area_name == input$selectArea | area_name == "England",
      school_phase == input$selectPhase
    )
  })

  # Define server logic required to draw a histogram
  output$lineRevBal <- renderPlotly({
    ggplotly(createAvgRevTimeSeries(reactiveRevBal(), input$selectArea)) %>%
      config(displayModeBar = F) %>%
      layout(legend = list(orientation = "h", x = 0, y = -0.2))
  })

  reactiveBenchmark <- reactive({
    dfRevBal %>%
      filter(
        area_name %in% c(input$selectArea, input$selectBenchLAs),
        school_phase == input$selectPhase,
        year == max(year)
      )
  })

  output$colBenchmark <- renderPlotly({
    ggplotly(
      plotAvgRevBenchmark(reactiveBenchmark()) %>%
        config(displayModeBar = F),
      height = 420
    )
  })

  output$tabBenchmark <- renderDataTable({
    datatable(
      reactiveBenchmark() %>%
        select(
          Area = area_name,
          `Average Revenue Balance (£)` = average_revenue_balance,
          `Total Revenue Balance (£m)` = total_revenue_balance_million
        ),
      options = list(
        scrollX = TRUE,
        paging = FALSE
      )
    )
  })

  # Define server logic to create a box

  output$boxavgRevBal <- renderValueBox({
    # Put value into box to plug into app
    valueBox(
      # take input number
      paste0("£", format(
        (reactiveRevBal() %>% filter(
          year == max(year),
          area_name == input$selectArea,
          school_phase == input$selectPhase
        ))$average_revenue_balance,
        big.mark = ","
      )),
      # add subtitle to explain what it's hsowing
      paste0("This is the latest value for the selected inputs"),
      color = "blue"
    )
  })

  output$boxpcRevBal <- renderValueBox({
    latest <- (reactiveRevBal() %>% filter(
      year == max(year),
      area_name == input$selectArea,
      school_phase == input$selectPhase
    ))$average_revenue_balance
    penult <- (reactiveRevBal() %>% filter(
      year == max(year) - 1,
      area_name == input$selectArea,
      school_phase == input$selectPhase
    ))$average_revenue_balance

    # Put value into box to plug into app
    valueBox(
      # take input number
      paste0("£", format(latest - penult,
        big.mark = ","
      )),
      # add subtitle to explain what it's hsowing
      paste0("This is the change on previous year"),
      color = "blue"
    )
  })

  output$boxavgRevBal_small <- renderValueBox({
    # Put value into box to plug into app
    valueBox(
      # take input number
      paste0("£", format(
        (reactiveRevBal() %>% filter(
          year == max(year),
          area_name == input$selectArea,
          school_phase == input$selectPhase
        ))$average_revenue_balance,
        big.mark = ","
      )),
      # add subtitle to explain what it's hsowing
      paste0("This is the latest value for the selected inputs"),
      color = "orange",
      fontsize = "small"
    )
  })

  output$boxpcRevBal_small <- renderValueBox({
    latest <- (reactiveRevBal() %>% filter(
      year == max(year),
      area_name == input$selectArea,
      school_phase == input$selectPhase
    ))$average_revenue_balance
    penult <- (reactiveRevBal() %>% filter(
      year == max(year) - 1,
      area_name == input$selectArea,
      school_phase == input$selectPhase
    ))$average_revenue_balance

    # Put value into box to plug into app
    valueBox(
      # take input number
      paste0("£", format(latest - penult,
        big.mark = ","
      )),
      # add subtitle to explain what it's hsowing
      paste0("This is the change on previous year"),
      color = "orange",
      fontsize = "small"
    )
  })

  output$boxavgRevBal_large <- renderValueBox({
    # Put value into box to plug into app
    valueBox(
      # take input number
      paste0("£", format(
        (reactiveRevBal() %>% filter(
          year == max(year),
          area_name == input$selectArea,
          school_phase == input$selectPhase
        ))$average_revenue_balance,
        big.mark = ","
      )),
      # add subtitle to explain what it's hsowing
      paste0("This is the latest value for the selected inputs"),
      color = "green",
      fontsize = "large"
    )
  })

  output$boxpcRevBal_large <- renderValueBox({
    latest <- (reactiveRevBal() %>% filter(
      year == max(year),
      area_name == input$selectArea,
      school_phase == input$selectPhase
    ))$average_revenue_balance
    penult <- (reactiveRevBal() %>% filter(
      year == max(year) - 1,
      area_name == input$selectArea,
      school_phase == input$selectPhase
    ))$average_revenue_balance

    # Put value into box to plug into app
    valueBox(
      # take input number
      paste0("£", format(latest - penult,
        big.mark = ","
      )),
      # add subtitle to explain what it's hsowing
      paste0("This is the change on previous year"),
      color = "green",
      fontsize = "large"
    )
  })





  observeEvent(input$link_to_app_content_tab, {
    updateTabsetPanel(session, "navlistPanel", selected = "dashboard")
  })

  # Download the underlying data button
  output$download_data <- downloadHandler(
    filename = "shiny_template_underlying_data.csv",
    content = function(file) {
      write.csv(dfRevBal, file)
    }
  )


  # Stop app ---------------------------------------------------------------------------------

  session$onSessionEnded(function() {
    stopApp()
  })
}
