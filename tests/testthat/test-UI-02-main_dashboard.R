# -----------------------------------------------------------------------------
# This is an example UI test file
# It includes some tests that show how to check the elements in the template
# have loaded correctly.
#
# In this script we show a two more way to test the UI of the app
# 1. create 'snapshots' of the state of the app (easiest to set up)
# 2. exporting values from the app and using here (recommended long term)
#
# Snapshots form the basic for future test runs to check to see if the app has
# changed at all, if it has it will fail and suggest you review the changes
#
# Deciding what to check for in snapshots is a tricky balance, often it's best
# to snapshot everything, review the .json file and then be very selective
# about what you care about tracking if it changes.
#
# Exporting values allows you to make tests that don't care about data updates
# or package updates or any other noise, and you can purely focus on what you
# want to check. They take more effort to set up but are worth it in the long
# run.
#
# You should adapt this script, and create additional scripts as necessary to
# match the needs for your app.
# -----------------------------------------------------------------------------
# Start an app running
app <- AppDriver$new(
  name = "basic_load",
  height = 846,
  width = 1445,
  load_timeout = 45 * 1000,
  timeout = 20 * 1000,
  wait = TRUE,
  expect_values_screenshot_args = FALSE # Turn off as we don't need screenshots
)

# Wait until Shiny is not busy for 5ms so we know any processes are complete
app$wait_for_idle(5)

# Chose a specific location using the drop downs
app$set_inputs(selectArea = "North East")

# Wait until Shiny is not busy for 50ms so we know any processes are complete
app$wait_for_idle(5)

# Capture specified values for average revenue balance box (raw snapshot)
app$expect_values(
  input = c("selectArea"), # Check location selected
  output = c("boxavgRevBal") # Output to snapshot
)

# Get the exported values, defined in server.R file using exportTestValues()
rev_bal_export <- app$get_values(export = c("boxavgRevBal_value"))

# Expect that the value in the box is always a £ symbol followed by numbers
# it accounts for commas being added if the numbers are large.
# This checks that there is a value present, it hasn't errored, and won't
# fail when you next update the data.
expect_true(
  grepl(
    # regex to check the value meets expected pattern
    "^£\\d{1,3}(,\\d{3})*$",
    rev_bal_export$export$boxavgRevBal_value
  )
)
