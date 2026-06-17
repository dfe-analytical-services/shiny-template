user_guide_panel <- function() {
  tabPanel(
    "User guide",
    gov_main_layout(
      gov_row(
        column(
          12,
          heading_text(
            level = 1,
            size = "l",
            "Department for Education (DfE) Analytical Services R Shiny data dashboard template"
          ),
          heading_text(
            level = 2,
            size = "m",
            "Introduction"
          ),
          gov_text(
            "This app demonstrates the DfE Analytical Services R Shiny data dashboard template."
          ),
          gov_text(
            "You might want to add some brief introductory text here alongside some links to
          different tabs within your dashboard. Here's an example of a link working:",
            actionLink("link_to_app_content_tab", "Example tab 1")
          ),
          gov_text(
            "You need to add an observeEvent() function to the server.R
                    script for any link that navigates within your App."
          ),
          heading_text(
            level = 2,
            size = "m",
            "Context and purpose"
          ),
          gov_text(
            "This app is the DfE Analytical Service's R-Shiny template
                  demonstration app and is being developed to provide a coherent
                  styling for DfE dashboards alongside some useful example
                  componenets that teams can adapt for their own uses."
          ),
          gov_text(
            "DfE teams using this template should avoid changing the
                  styling and layout, keeping the header, footer and side
                  navigation list formats."
          ),
          gov_text(
            "You might want to add some relevant background information
                  for your users here. For example some useful links to your
                  Explore Education Statistics (EES)
                  publication, data sources and other relevant resources."
          ),
          heading_text(
            level = 2,
            size = "m",
            "Guidance sources"
          ),
          gov_text(
            "For example, here we'll add some of the key resources we draw
                  on to guide styling and vizualisation..."
          )
        )
      )
    )
  )
}
