# ---------------------------------------------------------
# This is the ui file...
# Use it to...
#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
# ---------------------------------------------------------

ui <- function(input, output, session) {
  
  fluidPage(
    #theme = "acalat_theme.css",    # Need to update this to whichever style we want dept stuff to go out in.
    
    useShinyjs(),
    
    inlineCSS(appLoadingCSS),
    # set in global.r
    
    # Initial loading screen -------------------------------------------------------------------------------------------
    
    # Might as well keep this in the template, as good practice
    
    div(id = "loading-content",
        h2("Loading...")),
    
    hidden(div(
      id = "app-content",
      
      # Application title -----------------------------------------------------------------------------------
      
      # Might as well keep this in the template too, as good practice
      
      titlePanel(div(
        HTML("App title goes here <h4>Optional sub title can go here</h4>")
      ), windowTitle = "Short title"),
      
      # App code goes here -----------------------------------------------------------------------------------
      

      # Define UI for application that draws a histogram
      
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
          sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
            plotOutput("distPlot")
          )
        ),
      
      
      
      ## Should we add a standard footer or something for contact info and other useful disclaimers? 
      hr(),
      "Link back to relevant statistics on EES",
      br(),
      "Add contact details - ",
      br(),
      HTML("<a href=\"mailto:statistics.development@education.gov.uk\">statistics.development@education.gov.uk</a>")
      
   
      
    )) # End of app content (hidden during initial load)
  ) # End of ui
} # End of ui