# -----------------------------------------------------------------------------
# Script where we provide functions to read in the data file(s).
#
# IMPORTANT: Data files pushed to GitHub repositories are immediately public.
# You should not be pushing unpublished data to the repository prior to your
# publication date. You should use dummy data or already-published data during
# development of your dashboard.
#
# In order to help prevent unpublished data being accidentally published, the
# template will not let you make a commit if there are unidentified csv, xlsx,
# tex or pdf files contained in your repository. To make a commit, you will need
# to either add the file to .gitignore or add an entry for the file into
# datafiles_log.csv.
# -----------------------------------------------------------------------------

# Revenue data ----------------------------------------------------------------
read_revenue_data <- function(file = "data/la_maintained_schools_revenue_reserve_final.csv") {
  # This reads in an example file. For the purposes of this demo, we're using
  # the LA expenditure data downloaded from an EES release
  df_revenue <- read.csv(file)

  df_revenue <- df_revenue %>% mutate(
    # Convert 6 digit year to 4 digit for end year
    year = as.numeric(paste0("20", substr(format(time_period), 5, 6))),

    # Create a flat column listing all locations
    area_name = case_when(
      geographic_level == "National" ~ country_name,
      geographic_level == "Regional" ~ region_name,
      .default = la_name
    )
  )
  return(df_revenue)
}
