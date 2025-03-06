# -----------------------------------------------------------------------------
# This is the helper file, filled with lots of helpful functions!
#
# It is commonly used as an R script to store custom functions used through the
# app to keep the rest of the app code easier to read.
# -----------------------------------------------------------------------------

# Value box function ----------------------------------------------------------
# fontsize: can be small, medium or large
value_box <- function(value, subtitle, icon = NULL,
                      color = "blue", width = 4,
                      href = NULL, fontsize = "medium") {
  validate_color(color)
  if (!is.null(icon)) tagAssert(icon, type = "i")

  box_content <- div(
    class = paste0("small-box bg-", color),
    div(
      class = "inner",
      p(value, id = paste0("vboxhead-", fontsize)),
      p(subtitle, id = paste0("vboxdetail-", fontsize))
    ),
    if (!is.null(icon)) div(class = "icon-large", icon)
  )

  if (!is.null(href)) {
    box_content <- a(href = href, box_content)
  }

  div(
    class = if (!is.null(width)) paste0("col-sm-", width),
    box_content
  )
}

# Valid colours for value box -------------------------------------------------
valid_colors <- c("blue", "dark-blue", "green", "orange", "purple", "white")

# Validate that only valid colours are used -----------------------------------
validate_color <- function(color) {
  if (color %in% valid_colors) {
    return(TRUE)
  }

  stop(
    "Invalid color: ", color, ". Valid colors are: ",
    paste(valid_colors, collapse = ", "), "."
  )
}

# GSS colours -----------------------------------------------------------------
# Current GSS colours for use in charts. These are taken from the current
# guidance here:
# https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-colours-in-charts/
# Note the advice on trying to keep to a maximum of 4 series in a single plot
# AF colours package guidance here: https://best-practice-and-impact.github.io/afcolours/
suppressMessages(
  gss_colour_pallette <- afcolours::af_colours("categorical", colour_format = "hex", n = 4)
)

#' Create a Tabset Panel with Optional Tabs
#'
#' This function generates a `tabsetPanel` containing up to three tabs: "Chart",
#' "Table", and "Download".
#' Only non-NULL inputs will result in corresponding tabs being displayed.
create_output_tabs <- function(
    id,
    chart_output,
    table_output = NULL,
    download_output = NULL) {
  tabs <- Filter(Negate(is.null), list(
    if (!is.null(chart_output)) tabPanel("Chart", chart_output),
    if (!is.null(table_output)) {
      tabPanel(
        "Table",
        div(style = "margin-top: 20px;", table_output)
      )
    },
    if (!is.null(download_output)) {
      tabPanel(
        "Download",
        div(style = "margin-top: 40px;", download_output)
      )
    }
  ))

  do.call(tabsetPanel, c(list(id = paste0("main_tabs_", id)), tabs))
}

#' Standardise internal links ---------------------------------------------
#'
#' This function generates a link to an internal tabPanel (target_link),
#' with the link text specified in "link_text"
#' The following is required in the server.R script
#' 
#'   # navigation link within text --------------------------------------------
#' observeEvent(input$nav_link, {
#'   shiny::updateTabsetPanel(session, "navlistPanel", selected = input$nav_link)
#' })
#' 
#' The target location could be changed to a different UI element by 
#' changing the "navlistPanel" element of the server code

in_line_nav_link <- function(link_text, target_link) {
  HTML(paste0(
    "<a href='#' onclick=\"Shiny.setInputValue('nav_link', '",
    target_link,
    "', {priority: 'event'});\">",
    link_text,
    "</a>"
  ))
}
