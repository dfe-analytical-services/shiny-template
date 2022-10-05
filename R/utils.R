customDisconnectMessage <- function(refresh = "Refresh page",
                                    links = sites_list,
                                    publication_name=ees_pub_name,
                                    publication_link=ees_publication) {
  checkmate::assert_string(refresh)
  htmltools::tagList(
    htmltools::tags$script(
      paste0(
        "$(function() {",
        "  $(document).on('shiny:disconnected', function(event) {",
        "    $('#custom-disconnect-dialog').show();",
        "    $('#ss-overlay').show();",
        "  })",
        "});"
      )
    ),
    htmltools::tags$div(
      id = "custom-disconnect-dialog",
      style = "display: none !important;",
      htmltools::tags$div(
        id = "ss-connect-refresh",
        tags$p("You've lost connection to the dashboard server - please try refreshing the page:"),
        tags$p(tags$a(id = "ss-reload-link", 
                      href = "#", "Refresh page",
                      onclick = "window.location.reload(true);")),
        if(length(links)>1){
          tags$p("If this persists, you can also view the dashboard at one of our mirror sites:",
                 tags$p(
                   tags$a(href = links[1], "Site 1"),
                   " - ",
                   tags$a(href = links[2], "Site 2"),
                   if(length(links)==3){"-"},
                   if(length(links)==3){tags$a(href = links[3], "Site 3")}
                 )
          )
        },
        if(!is.null(publication_name)){
          tags$p("All the data used in this dashboard can also be viewed or downloaded via the ",
                 tags$a(href=publication_link,
                        publication_name),
                 "on Explore Education Statistics."
          )},
        tags$p("Please contact",
               tags$a(href="mailto:statistics.development@education.gov.uk","statistics.development@education.gov.uk"),
               "with details of any problems with this resource.")
        #  ),
        # htmltools::tags$p("If this persists, you can view tables and data via the ",htmltools::tags$a(href ='https://explore-education-statistics.service.gov.uk/find-statistics/pupil-attendance-in-schools', "Pupil attendance in schools")," release on Explore Education Statistics and please contact statistics.development@education.gov.uk with details of what you were trying to do.")
      )
    ),
    htmltools::tags$div(id = "ss-overlay", style = "display: none;"),
    htmltools::tags$head(htmltools::tags$style(
      glue::glue(
        .open = "{{", .close = "}}",
        "#custom-disconnect-dialog a {
             display: {{ if (refresh == '') 'none' else 'inline' }} !important;
             color: #1d70b8 !important;
             font-size: 16px !important;
             font-weight: normal !important;
          }"
      )
    )
    )
  )
}

