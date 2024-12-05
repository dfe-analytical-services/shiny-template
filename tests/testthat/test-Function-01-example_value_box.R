# -----------------------------------------------------------------------------
# This is an example unit test file.
#
# These examples show some ways you can make use of unit tests.
#
# Add more scripts and checks to test any other functions or non-shiny R code.
#
# Unit tests are easy to write and quick to run, make use of them where you can
# For more information, look at the testthat package documentation.
# -----------------------------------------------------------------------------
test_that("Example - two plus two equals four", {
  # Expect two objects to be the same
  expect_equal(2 + 2, 4)
  # Expect comparisons to be TRUE or FALSE
  expect_true(2 + 2 == 4)
  # Expect code to execute without error
  expect_no_error(2 + 2)
})

test_that("Value box function errors when no value is given", {
  # Note the path to the file is adjusted so that it works
  # when running shinytest2::test_app()
  source("../../R/helper_functions.R")

  # Expect an error if no value argument is given to value_box() function
  expect_error(value_box())
})
