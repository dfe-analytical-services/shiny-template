user_guide_panel <- function() {
  tabPanel(
    "User guide",
    gov_main_layout(
      gov_row(
        column(
          12,
          h1("Department for Education (DfE) Analytical Services R Shiny data dashboard template"),
          h2("Introduction"),
          p("This app demonstrates the DfE Analytical Services R Shiny data dashboard template."),
          p(
            "You might want to add some brief introductory text here alongside some links to
          different tabs within your dashboard. Here's an example of a link working:",
            actionLink("link_to_app_content_tab", "Example tab 1")
          ),
          p("You need to add an observeEvent() function to the server.R
                    script for any link that navigates within your App."),
          h2("Context and purpose"),
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
          h2("Guidance sources"),
          p("For example, here we'll add some of the key resources we draw
                  on to guide styling and vizualisation...")
        )
      )
    )
  )
}
