# -----------------------------------------------------------------------------
# This is the plotting.R file.
#
# This is where we've stored the functions for creating the plots in the app.
#
# It is up to you whether you put all plots in this script, move the plots to
# the helper_functions.R script or have a multiple scripts or even a folder of
# scripts that contain your custom plotting functions.
# -----------------------------------------------------------------------------

# Revenue balance time series line chart --------------------------------------
create_avg_rev_timeseries <- function(df, input_area) {
  ggplot(df, aes(
    x = year,
    y = average_revenue_balance,
    color = area_name,
    id = area_name
  )) +
    geom_line_interactive(size = 1) +
    geom_point_interactive(
      aes(
        tooltip = paste0(
          "<p><b>", area_name, ", ", year, "</b></p>",
          unlist(lapply(average_revenue_balance, pretty_num, prefix = gbp)), "</p>"
        )
      ),
      size = 0.5
    ) +
    theme_classic() +
    theme(
      text = element_text(size = 12),
      axis.title.x = element_text(margin = margin(t = 12)),
      axis.title.y = element_text(
        angle = 0, vjust = 0.5,
        margin = margin(r = 12)
      ),
      axis.line = element_line(linewidth = 0.75),
      legend.position = "top"
    ) +
    scale_y_continuous(
      labels = scales::number_format(accuracy = 1, big = ",", prefix = gbp)
    ) +
    xlab("Academic year end") +
    ylab(str_wrap("Average revenue balance", 16)) +
    scale_color_manual(
      "Area",
      breaks = unique(c("England", input_area)),
      values = gss_colour_pallette
    )
}

# Revenue balance bar chart ---------------------------------------------------
plot_avg_rev_benchmark <- function(df_revenue_balance, input_area) {
  ggplot(df_revenue_balance, aes(
    x = str_wrap(area_name, width = 12),
    y = average_revenue_balance,
    fill = area_name,
    id = area_name,
    tooltip = paste(
      "<p><b>", area_name, "</b></p>",
      unlist(lapply(average_revenue_balance, pretty_num, prefix = gbp)), "</p>"
    )
  )) +
    geom_col_interactive() +
    theme_classic() +
    theme(
      text = element_text(size = 12),
      axis.title.x = element_blank(),
      axis.title.y = element_text(
        angle = 0, vjust = 0.5,
        margin = margin(r = 12)
      ),
      axis.line = element_line(linewidth = 0.75),
      legend.position = "none"
    ) +
    scale_y_continuous(
      labels = scales::number_format(accuracy = 1, big = ",", prefix = gbp)
    ) +
    xlab("Area") +
    ylab(str_wrap("Average revenue balance", 12)) +
    scale_fill_manual(
      "Area",
      breaks = unique(df_revenue_balance$area_name),
      values = gss_colour_pallette
    )
}

# Timeseries Linechart server
timeseries_linechart_basic <- function(df) {
  # Long format LA data with tooltip included
  la_long <- tooltip_func(df) %>%
    rowwise() %>%
    mutate(lab = ifelse(year == max(df$year), area_name, ""))

  # Build main static plot
  line_chart <- ggplot2::ggplot(la_long) +
    ggiraph::geom_line_interactive(
      ggplot2::aes(
        x = year,
        y = average_revenue_balance,
        color = area_name,
        data_id = area_name
      ),
      na.rm = TRUE,
      linewidth = 1
    ) +
    ggplot2::aes(
      x = year,
      y = average_revenue_balance,
      label = lab
    ) +
    # geom_label_repel(xlim = c(-Inf, Inf), ylim = c(-Inf, Inf)) +
    geom_text_repel(
      xlim = c(NA, NA),
      ylim = c(NA, NA),
      nudge_x = 1,
      direction = "y",
      hjust = "left",
      min.segment.length = Inf
    ) +
    # Only show point data where line won't appear (NAs)
    ggplot2::geom_point(
      data = la_long,
      ggplot2::aes(
        x = year,
        y = average_revenue_balance,
        color = area_name
      ),
      shape = 15,
      size = 1,
      na.rm = TRUE
    ) +
    afcharts::theme_af() +
    theme(
      text = element_text(size = 12),
      axis.title.x = element_text(margin = margin(t = 12)),
      axis.title.y = element_text(
        angle = 0, vjust = 0.5,
        margin = margin(r = 12)
      ),
      axis.line = element_line(linewidth = 0.75),
      legend.position = "none"
    ) +
    scale_y_continuous(
      labels = scales::number_format(accuracy = 1, big = ",", prefix = "£")
    ) +
    xlab("Academic year end") +
    ylab(str_wrap("Average revenue balance", 12)) +
    scale_color_manual(
      "Area",
      breaks = unique(c("England", unique(la_long$area_name))),
      values = gss_colour_pallette
    )
  return(line_chart)
}

tooltip_func <- function(data) {
  master_tooltip <- data.frame(
    year = character(),
    tooltip = character()
  )

  years <- data %>%
    dplyr::select(year) %>%
    unique()

  for (i in seq_len(nrow(years))) {
    rel_data <- data %>%
      dplyr::filter(year == years$year[i])

    next_row <- data.frame(
      year = years$year[i],
      tooltip = paste(sapply(seq_len(nrow(rel_data)), function(i) {
        row <- rel_data[i, ]
        geography <- row$area_name
        value <- row$average_revenue_balance

        # Apply styling for geography
        if (geography == "England") {
          paste0(
            "<span style='color:", gss_colour_pallette[1], "; font-weight: bold;'>",
            geography, ": £", formatC(as.numeric(value), format = "f", digits = 0, big.mark = ","), "</span>"
          )
        } else {
          paste0(geography, ": £", formatC(as.numeric(value), format = "f", digits = 0, big.mark = ","))
        }
      }), collapse = "\n")
    )

    master_tooltip <- master_tooltip %>%
      rbind(next_row)
  }

  data_with_tooltip <- data %>%
    left_join(master_tooltip,
      by = "year"
    )
  return(data_with_tooltip)
}


generic_ggiraph_options <- function(...) {
  list(
    ggiraph::opts_tooltip(
      css = custom_ggiraph_tooltip(),
      opacity = 1
    ),
    ...
  )
}

custom_ggiraph_tooltip <- function() {
  tooltip_css <- paste0(
    "background-color:#ECECEC;",
    "color:black;",
    "padding:5px;",
    "border-radius:3px;",
    "font-family:Arial;",
    "font-weight:500;",
    "border:1px solid black;",
    "z-index: 99999 !important;"
  )

  tooltip_css
}
