app <- ShinyDriver$new("../../", loadTimeout = 6.4e4)
app$snapshotInit("initial_load_test", screenshot = FALSE)

app$snapshot()
