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
          unlist(lapply(average_revenue_balance, pretty_num, prefix = "£")), "</p>"
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
      labels = scales::number_format(accuracy = 1, big = ",", prefix = "£")
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
      unlist(lapply(average_revenue_balance, pretty_num, prefix = "£")), "</p>"
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
      labels = scales::number_format(accuracy = 1, big = ",", prefix = "£")
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
timeseries_LineChartServer <- function(df){
  # Long format LA data with tooltip included
  la_long <- tooltip_func(df)
  
  # Build main static plot
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
    # Only show point data where line won't appear (NAs)
    ggplot2::geom_point(
      data = subset(
        create_show_point(la_long),
        show_point
      ),
      ggplot2::aes(x = year,
                   y = average_revenue_balance, 
                   color = area_name),
      shape = 15,
      size = 1,
      na.rm = TRUE
    ) +
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
      labels = scales::number_format(accuracy = 1, big = ",", prefix = "£")
    ) +
    xlab("Area") +
    ylab(str_wrap("Average revenue balance", 12)) +
    scale_fill_manual(
      "Area",
      breaks = unique(la_long$area_name),
      values = gss_colour_pallette
    )
  
  # vertical hover part
  vertical_hover <- geom_vline_interactive(aes(
    xintercept = year,
    tooltip = paste(year, tooltip, sep = "\n\n"),
    data_id = year,
    hover_nearest = TRUE,
    linetype = "dashed",
    color = "transparent"),
    color = "transparent",
    linetype = "dashed",
    size = 3)
  
  # Plotting the graph
  chart_out <- ggiraph::girafe(
    ggobj = (line_chart + vertical_hover),
    options = generic_ggiraph_options(
      opts_hover(
        css = "stroke-dasharray:5,5;stroke:black;stroke-width:2px;"
      )
    ),
    fonts = list(sans = "Arial"),
    ,
    width_svg = 9.6,
    height_svg = 5.0
  )
  return(chart_out)
}

timeseries_LineChartServer_basic <- function(df){
  # Long format LA data with tooltip included
  la_long <- tooltip_func(df)
  
  # Build main static plot
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
    # Only show point data where line won't appear (NAs)
    ggplot2::geom_point(
      data = subset(
        create_show_point(la_long),
        show_point
      ),
      ggplot2::aes(x = year,
                   y = average_revenue_balance, 
                   color = area_name),
      shape = 15,
      size = 1,
      na.rm = TRUE
    ) +
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
      labels = scales::number_format(accuracy = 1, big = ",", prefix = "£")
    ) +
    xlab("Area") +
    ylab(str_wrap("Average revenue balance", 12)) +
    scale_fill_manual(
      "Area",
      breaks = unique(la_long$area_name),
      values = gss_colour_pallette
    )
  
  return(line_chart)
}

bad_func <- function(){
  # Line chart download ------------------------------------------------------
  # Initialise server logic for download button and modal
  DownloadChartBtnServer("download_btn", id, "Line")
  
  # Set up the download handlers for the chart
  Download_DataServer(
    "chart_download",
    reactive(input$file_type),
    reactive(line_chart),
    reactive("average_revenue_balance_line_chart")
  )
  
  # Plot used for copy to clipboard (hidden)
  output$copy_plot <- shiny::renderPlot(
    {
      line_chart()
    },
    res = 200,
    width = 24 * 96,
    height = 12 * 96
  )
  
  # Line chart plot ------------------------------------------------
  output$line_chart <- ggiraph::renderGirafe({
    interactive_line_chart()
  })
}

create_show_point <- function(data) {
 
  data %>%
    dplyr::group_by(
      area_name) %>%
    dplyr::arrange(area_name, year) %>%
    dplyr::mutate(
      # Helper: Is the current value NA
      is_na = is.na(average_revenue_balance),
      
      # General NA show point conditions to show isolated points
      show_point = dplyr::if_else(
        # Isolated in middle of plot
        (dplyr::lag(is_na) & dplyr::lead(is_na)) |
          # Isolated at start of plot
          (dplyr::row_number() == 1 & dplyr::lead(is_na)) |
          # Isolated at end of plot
          (dplyr::row_number() == dplyr::n() & dplyr::lag(is_na)),
        TRUE,
        FALSE
      )
    ) %>%
    dplyr::ungroup() %>%
    # Clean up - remove uneeded cols
    dplyr::select(-dplyr::starts_with("is_"))
}


tooltip_func <- function(data){
  master_tooltip <- data.frame(year = character(),
                               tooltip = character())
  
  years <- data %>%
    dplyr::select(year) %>%
    unique()
  
  for(i in 1:nrow(years)){
    rel_data <- data %>%
      dplyr::filter(year == years$year[i])
    
    next_row <- data.frame(year = years$year[i],
                           tooltip = paste(sapply(seq_len(nrow(rel_data)), function(i) {
                             row <- rel_data[i, ]
                             geography <- row$area_name
                             value <- row$average_revenue_balance
                             
                             # Apply styling for geography
                             if (geography == "England") {
                               paste0(
                                 "<span style='color:", "blue", "; font-weight: bold;'>",
                                 geography, ": £", formatC(as.numeric(value), format="f", digits=0, big.mark=","), "</span>"
                               )
                             } else {
                               paste0(geography, ": £", formatC(as.numeric(value), format="f", digits=0, big.mark=","))
                             }
                           }), collapse = "\n"))
    
    master_tooltip <- master_tooltip %>%
      rbind(next_row)
  }
  
  data_with_tooltip <- data %>%
    left_join(master_tooltip,
              by = 'year')
  return(data_with_tooltip)
}


generic_ggiraph_options <- function(...) {
  list(
    ggiraph::opts_tooltip(
      css = custom_ggiraph_tooltip(),
      opacity = 1
    ),
    ggiraph::opts_toolbar(
      position = "topright",
      hidden = c("selection", "zoom", "misc")
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


Download_DataServer <- function(id, file_type_input, data_for_download, download_name) {
  moduleServer(id, function(input, output, session) {
    # Reactive values for storing file path
    local <- reactiveValues(export_file = NULL, data = NULL, plot_width = NULL, file_type = NULL, file_name = NULL)
    
    # Observe changes in file type or data and generate export file
    observeEvent(list(file_type_input(), data_for_download(), download_name()), {
      # Ensure inputs are not NULL
      req(file_type_input(), data_for_download(), download_name())
      
      # Setting parameters
      local$file_type <- file_type_input()
      local$file_name <- paste0(download_name(),"_",Sys.Date())
      
      # For charts we need to pull the relevant object from the reactive list
      if (grepl("svg", local$file_type, ignore.case = TRUE)) {
        local$data <- data_for_download()$"svg"
        # Getting plot width from ggiraph obj ratio
        local$plot_width <- data_for_download()$"html"$x$ratio * 5
      } else if (grepl("html", local$file_type, ignore.case = TRUE)) {
        local$data <- data_for_download()$"html"
      } else {
        local$data <- data_for_download()
      }
      
      # Generate the file based on the selected file type
      local$export_file <- generate_download_file(local$data, local$file_type, local$plot_width)
    })
    
    # Download handler
    output$download <- create_download_handler(
      local
    )
  })
}

generate_download_file <- function(data, file_type, svg_width = 8.5) {
  out <- tempfile(fileext = dplyr::case_when(
    grepl("csv", file_type, ignore.case = TRUE) ~ ".csv",
    grepl("xlsx", file_type, ignore.case = TRUE) ~ ".xlsx",
    grepl("svg", file_type, ignore.case = TRUE) ~ ".svg",
    grepl("html", file_type, ignore.case = TRUE) ~ ".html",
    TRUE ~ "Error"
  ))
  
  if (grepl("csv", file_type, ignore.case = TRUE)) {
    write.csv(data, file = out, row.names = FALSE)
  } else if (grepl("xlsx", file_type, ignore.case = TRUE)) {
    openxlsx::write.xlsx(data, file = out, colWidths = "Auto")
  } else if (grepl("svg", file_type, ignore.case = TRUE)) {
    ggplot2::ggsave(filename = out, plot = data, width = svg_width, height = 6)
  } else if (grepl("html", file_type, ignore.case = TRUE)) {
    htmlwidgets::saveWidget(widget = data, file = out)
  }
  
  out
}