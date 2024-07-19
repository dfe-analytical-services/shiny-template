# -----------------------------------------------------------------------------
# This file contains scripts which are intended to provide standard styling
# across dashboards.
#
# If you want to change anything in this script, please
# talk to the Explore education statistics platforms team first.
# -----------------------------------------------------------------------------

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

valid_colors <- c("blue", "dark-blue", "green", "orange", "purple", "white")

validate_color <- function(color) {
  if (color %in% valid_colors) {
    return(TRUE)
  }

  stop(
    "Invalid color: ", color, ". Valid colors are: ",
    paste(valid_colors, collapse = ", "), "."
  )
}
