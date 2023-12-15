library(shinytest2)

app <- AppDriver$new(name = "basic_load", height = 846, width = 1445, load_timeout = 45 * 1000, timeout = 20 * 1000, wait = TRUE)

# Wait until Shiny is not busy for 500ms
app$wait_for_idle(500)

# Screenshots are left on for this script to help with troubleshooting
# They will not cause any failures if there's changes

inputs <- c(
  "cookieAccept", "cookieLink",
  "cookieReject", "cookies", "hideAccept", "hideReject",
  "link_to_app_content_tab",
  "navlistPanel",
  "plotly_afterplot-A",
  "selectArea", "selectBenchLAs", "selectPhase",
  "tabsetpanels"
)

outputs <- c(
  "boxavgRevBal", "boxavgRevBal_large", "boxavgRevBal_small",
  "boxpcRevBal", "boxpcRevBal_large", "boxpcRevBal_small",
  "dropdown_label",
  "lineRevBal",
  "colBenchmark"
)

test_that("App loads", {
  # Capture initial values
  app$expect_values(
    input = inputs,
    output = outputs
  )
})

app$set_inputs(tabsetpanels = "Line chart example")
test_that("Line chart created", {
  # Capture initial values
  app$expect_values(
    input = inputs,
    output = outputs
  )
})

app$set_inputs(tabsetpanels = "Benchmarking example")
test_that("Benchmarking panel", {
  # Capture initial values
  app$expect_values(
    input = inputs,
    output = outputs
  )
})
