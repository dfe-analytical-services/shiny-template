# -----------------------------------------------------------------------------
# This is an example integration test file
#
# Integration tests in Shiny allow you to test the server.R reactivity without
# needing to load a full app and interact with the UI.
#
# This makes integration tests faster to run than UI tests and makes them a
# more efficient alternative if you don't need to interact with the UI to test
# what you want to.
#
# These examples show some ways you can make use of integration tests.
#
# Add more scripts and checks as appropriate for your app.
# -----------------------------------------------------------------------------

# Read in the data to test against
# Note that when running tests you need to write the paths from the point of view
# of the tests folder
source("../../R/read_data.R")
test_data <- read_revenue_data(
  file = "../../data/la_maintained_schools_revenue_reserve_final.csv"
)

# Test the server file --------------------------------------------------------
shiny::testServer(expr = {
  # Give the inputs expected on initial load
  session$setInputs(
    navlistPanel = "Example tab 1",
    selectArea = "England",
    selectPhase = "All Local authority maintained schools"
  )

  # Check the reactive data frame is being filtered down by the dropdowns as we'd expect it to be
  expect_identical(
    # Reactive data set
    reactive_rev_bal(),

    # Example of what we're expecting made from test data
    test_data %>%
      filter(
        area_name == "England",
        school_phase == "All Local authority maintained schools"
      )
  )

  # Change to a different dropdown selection
  session$setInputs(
    selectArea = "North East",
    selectPhase = "Secondary"
  )

  # Check the reactive data frame is being filtered down by the dropdowns as we'd expect it to be
  expect_identical(
    reactive_rev_bal(),
    test_data %>%
      filter(
        area_name %in% c("England", "North East"),
        school_phase == "Secondary"
      )
  )
})
