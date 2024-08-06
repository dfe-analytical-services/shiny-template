a11y_panel <- function() {
  tabPanel(
    "Accessibility",
    gov_main_layout(
      gov_row(
        column(
          width = 12,
          h1("Accessibility statement for [service name]"), # TODO
          p(
            "This accessibility statement applies to the [raw service URL] website. This website is run by the", # TODO
            a(
              href = "https://www.gov.uk/government/organisations/department-for-education",
              "Department for Education (DfE)",
              .noWS = "after"
            ), ".",
            "This statement does not cover any other services run by the Department for Education (DfE) or GOV.UK."
          ),
          h2("How you should be able to use this website"),
          p("We want as many people as possible to be able to use this website. You should be able to:"),
          tags$div(tags$ul(
            tags$li("change colours, contrast levels and fonts using browser or device settings"),
            tags$li("zoom in up to 400% without the text spilling off the screen"),
            tags$li("navigate most of the website using a keyboard or speech recognition software"),
            tags$li("listen to most of the website using a screen reader
                    (including the most recent versions of JAWS, NVDA and VoiceOver)")
          )),
          p("We’ve also made the website text as simple as possible to understand."),
          p(
            a(href = "https://mcmw.abilitynet.org.uk/", "AbilityNet"),
            " has advice on making your device easier to use if you have a disability."
          ),
          h2("How accessible this website is"),
          p("We know some parts of this website are not fully accessible:"),
          tags$div(tags$ul(
            tags$li("list them here") # TODO
          )),
          h2("Feedback and contact information"),
          p(
            "If you need information on this website in a different format please see the ",
            a(
              href = "", # TODO
              "[source publication] on Explore education statistics", # TODO
              .noWS = "after"
            ),
            ". More details are available on that service for alternative formats of this data.",
          ),
          p("We’re always looking to improve the accessibility of this website.
             If you find any problems not listed on this page or think we’re not meeting
             accessibility requirements, contact us:"),
          tags$ul(tags$li(
            a(
              href = "mailto:explore.statistics@education.gov.uk",
              "explore.statistics@education.gov.uk"
            )
          )),
          h2("Enforcement procedure"),
          p("The Equality and Human Rights Commission (EHRC) is responsible for enforcing the Public Sector Bodies
             (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018
             (the ‘accessibility regulations’)."),
          p(
            "If you are not happy with how we respond to your complaint, ",
            a(
              href = "https://www.equalityadvisoryservice.com/",
              "contact the Equality Advisory and Support Service (EASS)",
              .noWS = "after"
            ),
            "."
          ),
          h2("Technical information about this website's accessibility"),
          p("The Department for Education (DfE) is committed to making its website accessible, in accordance with the
          Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018."),
          h3("Compliance status"),
          p(
            "This website is partially compliant with the", # TODO
            a(
              href = "https://www.w3.org/TR/WCAG21/",
              "Web Content Accessibility Guidelines version 2.1 AA standard",
              .noWS = "after"
            ),
            " due to the non-compliances listed below."
          ),
          h3("Non accessible content"),
          p("The content listed below is non-accessible for the following reasons.
             We will address these issues to ensure our content is accessible."),
          tags$div(tags$ul(
            tags$li("list them here") # TODO
          )),
          h3("Disproportionate burden"),
          p("Not applicable."),
          h2("How we tested this website"),
          p(
            "The template used for this website was last tested on 12 March 2024 against",
            a(
              href = "https://www.w3.org/TR/WCAG22/",
              "Accessibility Guidelines WCAG2.2",
              .noWS = "after"
            ),
            ". The test was carried out by the",
            a(
              href = "https://digitalaccessibilitycentre.org/",
              "Digital accessibility centre (DAC)",
              .noWS = "after"
            ),
            "."
          ),
          p("DAC tested a sample of pages to cover the core functionality of the service including:"),
          tags$div(tags$ul(
            tags$li("navigation"),
            tags$li("interactive dropdown selections"),
            tags$li("charts, maps, and tables")
          )),
          p(
            "This specific website was was last tested on [date] against", # TODO
            a(
              href = "https://www.w3.org/TR/WCAG22/",
              "Accessibility Guidelines WCAG2.2",
              .noWS = "after"
            ),
            ". The test was carried out by the",
            a(
              href = "https://www.gov.uk/government/organisations/department-for-education",
              "Department for Education (DfE)",
              .noWS = "after"
            ),
            "."
          ),
          h2("What we're doing to improve accessibility"),
          p("We plan to continually test the service for accessibility issues, and are working through a prioritised
          list of issues to resolve."),
          p(
            "Our current list of issues to be resolved is available on our ",
            a(
              href = "", # TODO
              "[GitHub issues page]", # TODO
              .noWS = "after"
            ),
            "."
          ),
          h2("Preparation of this accessibility statement"),
          p("This statement was prepared on 1st July 2024. It was last reviewed on [date]."), # TODO
          p(
            "The template used for this website was last testing in March 2024 against the WCAG 2.2 AA standard.
          This test of a representative sample of pages was carried out by the",
            a(
              href = "https://digitalaccessibilitycentre.org/",
              "Digital accessibility centre (DAC)",
              .noWS = "after"
            ),
            "."
          ),
          p("We also used findings from our own testing when preparing this accessibility statement.")
        )
      )
    )
  )
}
