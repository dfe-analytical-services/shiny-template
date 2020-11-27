app <- ShinyDriver$new("../../")
app$snapshotInit("initial_load_test", screenshot = FALSE)

app$snapshot()
