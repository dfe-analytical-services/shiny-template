a11y_panel <- function() {
  tabPanel(
    "Accessibility",
    gov_main_layout(
      gov_row(
        column(
          width = 12,
          h1("Accessibility statement"),
          br("This website is run by the", a(href = "https://www.gov.uk/government/organisations/department-for-education", "Department for Education (DfE).", ""), 
             "We want as many people as possible to be able to use this website. 
             For example, that means you should be able to:"),
          tags$div(tags$ul(
            tags$li("change colours, contrast levels and fonts"),
            tags$li("zoom in up to 300% without the text spilling off the screen"),
            tags$li("navigate most of the website using just a keyboard"),
            tags$li("navigate most of the website using speech recognition software"),
            tags$li("listen to most of the website using a screen reader (including the most recent versions of JAWS, NVDA and VoiceOver)")
          )),
          br("We’ve also made the website text as simple as possible to understand."),
          br(a(href = "https://mcmw.abilitynet.org.uk/", "AbilityNet", ""), " has advice on making your device easier to use if you have a disability."),
          h2("How accessible this website is"),
          br("We know some parts of this website are not fully accessible:"),
          tags$div(tags$ul(
            tags$li("list them here")
          )),
          h2("What to do if you cannot access parts of this website"),
          br("If you need information on this website in a different format like accessible PDF, 
             large print, easy read, audio recording or braille, email"), 
          br((a(href="mailto:explore.statistics@education.gov.uk", "explore.statistics@education.gov.uk", ""))),
          h2("Reporting accessibility problems with this website"),
          br("We’re always looking to improve the accessibility of this website. 
             If you find any problems not listed on this page or think we’re not meeting accessibility requirements, contact us:"),
          br((a(href="mailto:explore.statistics@education.gov.uk", "explore.statistics@education.gov.uk", ""))),
          h2("Technical information about this website's accessibility"),
          br("The Department for Education (DfE) is committed to making its website accessible, in accordance with the Public Sector Bodies (Websites and Mobile Applications) 
              (No. 2) Accessibility Regulations 2018.
              This website is partially compliant with the", a(href = "https://www.w3.org/TR/WCAG21/", "Web Content Accessibility Guidelines version 2.1 AA standard", ""),
             " due to the non-compliances listed below."),
          h2("Non accessible content"),
          br("The content listed below is non-accessible for the following reasons. 
             We will address these issues to ensure our content is accessible."),
          tags$div(tags$ul(
            tags$li("list them here")
          )),
          h2("How we tested this website"),
          br("This website was last tested on 27 September 2022 against", a(href = "https://www.w3.org/TR/WCAG21/", "Accessibility Guidelines WCAG2.1.", ""), 
              "The test was carried out by the", a(href="https://digitalaccessibilitycentre.org/", "Digital accessibility centre (DAC).", ""),
              "DAC tested a sample of pages to cover the core functionality of the service including:"),
          tags$div(tags$ul(
            tags$li("list them here")
          )),
          h2("What we're doing to improve accessibility"),
          br("We plan to continually test the service for accessibility issues. Our current list of issues to be resolved is:"),
          tags$div(tags$ul(
            tags$li("list of github issues here")
          )),
          h2("Preparation of this accessibility statement"),
          br("This statement was prepared on 1st July 2024. It was last reviewed on 1st July 2024.")
        )
      )
    )
  )
}
