# This file contains scripts which are intended to provide standard styling
# across dashboards. If you want to change anything in this script, please
# talk to the DfE Statistics Development team first.

# message("Sourcing dfe_template")
valueBox <- function(value, subtitle, icon = NULL,
                     color = "blue", width = 4,
                     href = NULL, fontsize = "medium")
# fontsize: can be small, medium or large
{
  validateColor(color)
  if (!is.null(icon)) tagAssert(icon, type = "i")

  boxContent <- div(
    class = paste0("small-box bg-", color),
    div(
      class = "inner",
      p(value, id = paste0("vboxhead-", fontsize)),
      p(subtitle, id = paste0("vboxdetail-", fontsize))
    ),
    if (!is.null(icon)) div(class = "icon-large", icon)
  )

  if (!is.null(href)) {
    boxContent <- a(href = href, boxContent)
  }

  div(
    class = if (!is.null(width)) paste0("col-sm-", width),
    boxContent
  )
}

validColors <- c("blue", "dark-blue", "green", "orange", "purple", "white")

validateColor <- function(color) {
  if (color %in% validColors) {
    return(TRUE)
  }

  stop(
    "Invalid color: ", color, ". Valid colors are: ",
    paste(validColors, collapse = ", "), "."
  )
}
