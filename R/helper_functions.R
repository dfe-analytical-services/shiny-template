# -----------------------------------------------------------------------------
# This is the helper file, filled with lots of helpful functions!
#
# It is commonly used as an R script to store custom functions used through the
# app to keep the rest of the app code easier to read.
# -----------------------------------------------------------------------------

# Expandable function ---------------------------------------------------------
expandable <- function(input_id, label, contents) {
  gov_details <- shiny::tags$details(
    class = "govuk-details", id = input_id,
    shiny::tags$summary(
      class = "govuk-details__summary",
      shiny::tags$span(
        class = "govuk-details__summary-text",
        label
      )
    ),
    shiny::tags$div(contents)
  )
}

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
