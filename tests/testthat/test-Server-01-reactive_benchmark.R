# # -----------------------------------------------------------------------------
# # This is an example integration test file
# #
# # Integration tests in Shiny allow you to test the server.R reactivity without
# # needing to load a full app and interact with the UI.
# #
# # This makes integration tests faster to run than UI tests and makes them a
# # more efficient alternative if you don't need to interact with the UI to test
# # what you want to.
# #
# # These examples show some ways you can make use of integration tests.
# #
# # Add more scripts and checks as appropriate for your app.
# # -----------------------------------------------------------------------------
# testServer(expr = {
#   # Give the inputs expected on initial load
#   session$setInputs(
#     navlistPanel = "dashboard",
#     region = "England",
#     selectPhase = "All local authority maintained schools",
#     tabsetpanels = "Benchmark example",
#     selectBenchLAs = ""
#   )
#
#   # Check the reactive benchmark value is a valid number
#   #expect_true(grepl("^\\d*$", reactive_benchmark()))
#
#   # Check the output has expected number of rows for benchmark table
#   #expect_equal(nrow(output$tabBenchmark), 1)
#
#   # Change to a different dropdown selection
#   session$setInputs(
#     navlistPanel = "dashboard",
#     region = "North East",
#     selectPhase = "Secondary",
#     tabsetpanels = "Benchmarking example",
#     selectBenchLAs = c("Barnsley", "Doncaster")
#   )
#
#
#   # Check the reactive benchmark table is a valid number
#   # expect_true(grepl("^\\d*$", reactive_benchmark()))
#
#   print(reactive_benchmark())
#   print(output$tabBenchmark)
#
#   reac_benc_tab <<- output$tabBenchmark
#
#   # Check the output has expected number of rows for benchmark table
#   expect_equal(nrow(reactive_benchmark()), 3)
#
#
# })
