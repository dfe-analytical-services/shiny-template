library(shinytest2)

app <- AppDriver$new(name = "basic_load", height = 846, width = 1445, load_timeout = 45 * 1000, timeout = 20 * 1000, wait = TRUE)

# Wait until Shiny is not busy for 500ms
app$wait_for_idle(500)

# Screenshots are left on for this script to help with troubleshooting
# They will not cause any failures if there's changes

test_that("App loads", {
  # Capture initial values
  app$expect_values()
})
