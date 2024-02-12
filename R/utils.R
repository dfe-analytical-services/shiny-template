customDisconnectMessage <- function(refresh = "Refresh page",
                                    links = sites_list,
                                    publication_name = ees_pub_name,
                                    publication_link = ees_publication) {
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
        tags$p(tags$a(
          id = "ss-reload-link",
          href = "#", "Refresh page",
          onclick = "window.location.reload(true);"
        )),
        if (length(links) > 1) {
          tags$p(
            "If this persists, you can also view the dashboard at one of our mirror sites:",
            tags$p(
              tags$a(href = links[1], "Site 1"),
              " - ",
              tags$a(href = links[2], "Site 2"),
              if (length(links) == 3) {
                "-"
              },
              if (length(links) == 3) {
                tags$a(href = links[3], "Site 3")
              }
            )
          )
        },
        if (!is.null(publication_name)) {
          tags$p(
            "All the data used in this dashboard can also be viewed or downloaded via the ",
            tags$a(
              href = publication_link,
              publication_name
            ),
            "on Explore Education Statistics."
          )
        },
        tags$p(
          "Please contact",
          tags$a(href = "mailto:statistics.development@education.gov.uk", "statistics.development@education.gov.uk"),
          "with details of any problems with this resource."
        )
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
    ))
  )
}

cookieBannerUI <- function(id, name = "DfE R-Shiny dashboard template"){
  tags$div(
    id=NS(id,"cookieDiv"),
    class="govuk-cookie-banner",
    `data-nosnippet role`="region",
    `aria-label`="Cookies on name",
    tags$div(
      id=NS(id,"cookieMain"),
      class="govuk-cookie-banner__message govuk-width-container",
      tags$div(
        class="govuk-grid-row",
        tags$div(
          class="govuk-grid-column-two-thirds",
          tags$h2(
            class="govuk-cookie-banner__heading govuk-heading-m",
            name),
          tags$div(
            class="govuk-cookie-banner__content",
            tags$p(
              class="govuk-body",
              "We use some essential cookies to make this service work."
              ),
            tags$p(
              class="govuk-body",
              "We'd also like to use analytics cookies so we can understand
              how you use the service and make improvements."
              )
          )
        )
      ),
      tags$div(
        class="govuk-button-group",
        actionButton(NS(id,"cookieAccept"), label = "Accept analytics cookies"),
        actionButton(NS(id,"cookieReject"), label =  "Reject analytics cookies"),
        actionButton(NS(id,"cookieLink"), label = "View cookies")
        )
      )
    )
}

cookieBannerServer <- function(id, input.cookies=NULL, input.remove=NULL) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input.cookies(), {
      print(input.cookies()$`_ga_Z967JJVQQX`)
      print(input.cookies()$dfe_analytics)
      if (!is.null(input.cookies())) {
        if (!("dfe_analytics" %in% names(input.cookies()))) {
          shinyjs::show(id = "cookieMain")
        } else {
          shinyjs::hide(id = "cookieMain")
          msg <- list(
            name = "dfe_analytics",
            value = input.cookies()$dfe_analytics
          )
          session$sendCustomMessage("analytics-consent", msg)
          if ("cookies" %in% names(input)) {
            if ("dfe_analytics" %in% names(input.cookies())) {
              if (input.cookies()$dfe_analytics == "denied") {
                ga_msg <- list(name = paste0("_ga_", google_analytics_key))
                session$sendCustomMessage("cookie-remove", ga_msg)
              }
            }
          }
        }
      } else {
        shinyjs::hide(id = "cookieMain", asis = TRUE)
        shinyjs::toggle(id = "cookieDiv", asis = TRUE)
      }
    })
    
    # Check for the cookies being authorised
    observeEvent(input$cookieAccept, {
      print("cookieAccept pressed")
      msg <- list(
        name = "dfe_analytics",
        value = "granted"
      )
      session$sendCustomMessage("cookie-set", msg)
      session$sendCustomMessage("analytics-consent", msg)
      shinyjs::hide(id = "cookieMain", asis = TRUE)
      shinyjs::show(id = "cookieAcceptDiv", asis = TRUE)
    })
    
    # Check for the cookies being rejected
    observeEvent(input$cookieReject, {
      print("cookieReject pressed")
      msg <- list(
        name = "dfe_analytics",
        value = "denied"
      )
      session$sendCustomMessage("cookie-set", msg)
      session$sendCustomMessage("analytics-consent", msg)
      shinyjs::hide(id = "cookieMain", asis = TRUE)
      shinyjs::show(id = "cookieRejectDiv", asis = TRUE)
    })
    
    observeEvent(input$cookieLink, {
      # Need to link here to where further info is located.  You can
      # updateTabsetPanel to have a cookie page for instance
      print("cookieLink pressed")
      updateTabsetPanel(session, "navlistPanel", selected = "Support and feedback")
    })

    observeEvent(input.remove(), {
      shinyjs::toggle(id = "cookieMain")
      msg <- list(name = "dfe_analytics", value = "denied")
      session$sendCustomMessage("cookie-remove", msg)
      session$sendCustomMessage("analytics-consent", msg)
      print(input$cookies)
    })
    
  })
}
