# Department for Education template R Shiny application

---

## Introduction 

**Before using this template, please contact the Explore education statistics platforms team (explore.statistics@education.gov.uk) to discuss your plans for creating a DfE dashboard.**

This template repository is for making accessible apps for published statistics in DfE. It includes a basic shiny app with DfE styling and example components, as well as templates for additional best practice documents like the README script, pull request templates and codes of conduct for contributing.

This template app is deployed in the following places for you to view:

- Public production - https://department-for-education.shinyapps.io/dfe-shiny-template/

We have guidance on [creating public dashboards](https://dfe-analytical-services.github.io/analysts-guide/writing-visualising/dashboards.html) and [creating dashboards in R Shiny](https://dfe-analytical-services.github.io/analysts-guide/writing-visualising/dashboards_rshiny.html) that you should familiarise yourself with before using this template.

---

## Using this template

If you wish to begin developing an official DfE dashboard, then contact the explore education statistics platforms team to arrange a new dashboard repository based on this template in the dfe-analytical-services GitHub area. 

If you just want to experiment with the template first, you can create your own copy of the template by clicking the "<> Code" button and then clicking "Download ZIP". You can then save your dashboard template copy into another repo manually, though note that all DfE dashboards must be held within the dfe-analytical-services area and you should minimise any code that is held in personal repositories.

---

### New application checklist

---

Once you have a new repository set up from this template, you should start by taking the following actions. If you have any issues while running these please contact explore.statistics@gov.uk for support.

#### Check you can run it

1. Check that you can run the app successfully using the instructions in this README
2. Check that the example automated tests also run successfully using `shinytest2::test_app()`<br>
(If you get `Error in initialize(...) : Invalid path to Chrome`, the Analyst's Guide has a solution - [shinytest2 - Invalid path to Chrome (chromote) error message](https://dfe-analytical-services.github.io/analysts-guide/learning-development/r.html#shinytest2---invalid-path-to-chrome-chromote-error-message))

#### Update standard variables

3. Update the app title, set by the `site_title` variable in the `global.R` script (and the HTML `<title>` tag in the `ui.R` script), and the expected title in the `tests/testthat/test-UI-01-basic_load.R` UI test script
4. Update the rest of the app metadata set in the `ui.R` script
5. Update the other variables set in the `global.R` script (source publication name and link, `site_primary` URL and `google_analytics_key`)
6. Test that the app still loads okay in the tests using `shinytest2::test_app()`
7. Note: You may get a failure for the test in `test-UI-01-basic_load.R`, with a reason similar to `app$get_text("title") not equal to ...`. See this [workaround for the failure of the UI test](#ui-test-fail).

Finally before adding your own code, you should update the readme, deleting this version and then replacing with your own content applicable to your dashboard based on the README_template.md file in this repository. Once done you should also delete that template, leaving you with a single `README.md` file that documents an overview of your application. Continue to edit and maintain that as a key document for your application over time.

#### Set up other things

Before publishing there will be a number of other things you wish to set up. You can do some of these using the functions starting with `init_` from the `dfeshiny` package. More guidance on these steps, including walk-through guides can be found on the [dfeshiny package documentation site](https://dfe-analytical-services.github.io/dfeshiny/).

* User analytics using Google Analytics using `dfeshiny::init_analytics()`
* Cookies tracking using `dfeshiny::init_cookies()` and following the [guide to using the cookies functions in dfeshiny](https://dfe-analytical-services.github.io/dfeshiny/articles/implementing-cookies.html)
* Deployment settings, update `dashboard_name` (and `deploy_target` if needed) in the `deploy-parameters.yaml` file
* Deployment keys, to deploy to shinyapps.io and make a dashboard public, you will need to contact explore.statistics@education.gov.uk for them to add the deployment keys (`SHINYAPPS_TOKEN` and `SHINYAPPS_SECRET`) as secure variables in your repository to then allow the `.github/workflows/deploy-shiny.yaml` workflow to run successfully

---

## Requirements

The following requirements are necessary for running the application yourself or contributing to it.

### i. Software requirements (for running locally)

- Installation of R Studio 2024.04.2+764 "Chocolate Cosmos" or higher

- Installation of R 4.6.1 or higher (the version recorded in `renv.lock`)

- Installation of the RTools version that matches your R version

### ii. Programming skills required (for editing or troubleshooting)

- R at an intermediate level, [DfE R leanring resources](https://dfe-analytical-services.github.io/analysts-guide/learning-development/r.html)

- Particularly [R Shiny](https://shiny.rstudio.com/)

### iii. Access requirements

To contribute to the repo you will need to be given access to create new branches, commit and push / pull, contact explore.statistics@education.gov.uk for this.

There are no other access requirements as all example data is available in the repository

---

## How to use

### Running the app locally

1. Clone or download the repo. 

2. Open the R project in R Studio.

3. Run `renv::restore()` to install dependencies.

4. Run `shiny::runApp()` to run the app locally.

### Folder structure

The app is built from three core scripts in the root of the repository: `global.R`, `server.R` and `ui.R`.

#### global.R

Runs once when the app launches, before the server and UI, and is shared across all users. It:

- Loads the packages used by the app (and lists CI/testing-only packages inside `if (FALSE)` so renv records them without the app loading them)
- Sources `R/read_data.R`, `R/helper_functions.R` and every script in `R/ui_panels/`
- Sets the global variables, including `site_title`, the parent publication name and link, the `site_primary` URL and `google_analytics_key`
- Enables URL bookmarking and registers the DejaVu fonts used in charts
- Reads in the data and builds the lookup lists used in the dropdowns (areas, local authorities, phases and years)

#### server.R

Creates the interactive elements of the app in response to user inputs. It:

- Handles bookmarking, storing input choices in the URL (with a list of inputs to exclude)
- Updates the browser window title based on the selected phase and area
- Handles navigation between the main panels
- Runs the dfeshiny cookies banner and cookies panel server logic
- Builds the reactive datasets and outputs for the example tab, including the time series and benchmarking charts, the leaflet map, reactable tables, value boxes and data download buttons
- Exports the value box values with `exportTestValues()` so they can be checked in the UI tests

#### ui.R

Defines the layout of the app and the user inputs, using `shinyGovstyle` and `bslib` components. It:

- Sets the app metadata (page title, favicon, language and meta description)
- Adds the dfeshiny custom disconnect message, cookies script and banner, and the Google Analytics tag
- Adds the GOV.UK header, service navigation, beta banner and footer
- Lays out the main panels (`example_tab_1_panel()` and `user_guide_panel()`) alongside the accessibility statement, cookies and support and feedback pages

#### Other scripts and folders

All R code outside of the core `global.R`, `server.R`, and `ui.R` files is stored in the `R/` folder:

- `R/read_data.R` - functions for loading the example data (`read_revenue_data()` and `read_upper_tier_data()`)
- `R/helper_functions.R` - common custom functions, such as `value_box()`, `create_output_tabs()` and `in_line_nav_link()`
- `R/plotting.R` - chart functions built with ggiraph
- `R/ui_panels/` - scripts for the different UI panels (`example_tab_1.R` and `user_guide.R`), all of which are sourced in `global.R`

Example data, including the GeoJSON boundary files used for the map, is stored in the `data/` folder and every data file must be recorded in `datafiles_log.csv`. Static assets such as CSS, fonts and images are stored in the `www/` folder.

### Connecting your dashboard to data

There are three ways to connect a dashboard to its data. Whichever you choose, remember that anything pushed to a public GitHub repository is immediately public, so never commit unpublished data. Use dummy or already-published data while developing.

#### 1. Store data in the repository

This is the approach used by this template. Data files are saved in the `data/` folder and read in by the functions in `R/read_data.R`, which are called from `global.R`.

- Best for small, published or reference data files that change infrequently
- Every data file must be recorded in `datafiles_log.csv` with a status of published, reference, dummy or unpublished. The pre-commit hook will block the commit if a file isn't logged, or if unpublished data isn't covered by `.gitignore`
- Files are bundled with the app when it is deployed, so no extra set-up is needed
- GitHub warns about files over 50 MB and blocks files over 100 MB, so this isn't suitable for large datasets

#### 2. Use Git Large File Storage (Git LFS)

[Git LFS](https://git-lfs.com/) stores large files outside of the main Git history and keeps a small pointer file in the repository in their place. An example of a dashboard set up to use Git LFS can be found in the [git_lfs branch of this repository](https://github.com/dfe-analytical-services/shiny-template/tree/git_lfs).

- Best for data files too large to store directly in the repository
- Install Git LFS, run `git lfs install` once, then use `git lfs track` to choose which files to track (for example `git lfs track "data/*.csv"`), and commit the resulting `.gitattributes` file
- Anyone cloning the repository, and any GitHub Actions workflows that test or deploy the app, need to download the LFS files rather than the pointer files
- Files stored with Git LFS in a public repository are still public, and the datafiles_log.csv rules still apply
- Git LFS storage and bandwidth are subject to GitHub quotas

#### 3. Pull data from the EES public API

If your data is published on Explore education statistics (EES) as an API data set, the dashboard can query it directly from the EES public API instead of storing a copy. The [eesyapi R package](https://dfe-analytical-services.github.io/eesyapi.R/) provides functions for finding publications and data sets, reading their metadata and querying the data.

- Best for dashboards built on data that is already published on EES, as the dashboard can pick up new releases without data files being updated in the repository
- Install eesyapi from GitHub and record it with `renv::snapshot()`
- The dashboard depends on the API being available, so consider caching results and handling errors gracefully
- Only published data is available, so you will still need dummy data for development before publication

### Packages

Package control is handled using renv. As in the steps above, you will need to run `renv::restore()` if this is your first time using the project.

Whenever you add new packages, make sure to use `renv::snapshot()` to record them in the `renv.lock` file.

#### Known issues

##### renv

We've found that some packages have particular issues with backwards / forwards compatibility when using different versions of R. 

You'll hit this if you have older versions of some packages but have updated your R version, and you'll see install issues when running `renv::restore()`.

We commonly see this with MASS and Matrix.

To solve this issue, you should try recording the latest versions of these packages individually in the lockfile and replacing the package version with the latest available version on CRAN.

To install specific package versions use @ to specify the version, for example:
```
renv::record("MASS@7.3-61")
```

Once you've recorded the newest versions, try running `renv::restore()` again to install the versions of the packages now specified, all going well, the latest versions should work with the latest version of R. 

Be mindful that updating package versions can change behaviour, so make sure to test your dashboard thorough and check all automated tests are still passing after making any package updates.

##### UI test fail

Lines 56 to 76 in the `server.R` script are used to change the app title dependent on some selections. On load, the title is `site_title` followed by the selected phase and area, for example "DfE Shiny Template - All Local authority maintained schools, England", and the test in `tests/testthat/test-UI-01-basic_load.R` expects this full title.

Updating the app title in the `global.R` script and the `tests/testthat/test-UI-01-basic_load.R` UI test script may lead to an error when `shinytest2::test_app()` is run. The error may look something similar to:

```
── Failed tests ──────────────────────────────────────────────────────────────────────────────────────────────────────────
Failure (test-UI-01-basic_load.R:29:3): App loads and title of app appears as expected
app$get_text("title") not equal to "Your new app title".
1/1 mismatches
x[1]: "Your new app title - All Local authority maintained schools, England"
y[1]: "Your new app title"
```

To fix / workaround this, either include the selection suffix in the expected title in the test, or comment out or delete lines 56 to 76 in the `server.R` script.

However, this feature can be helpful. For example, if you have lots of tabs / pages in your dashboard to switch the title depending on which one a user is looking at. But, its biggest value is for screen readers and assistive tech users, as they will get an announcement every time the title changes.
So, note this may be a useful feature for later on in your app development.

### Tests

Automated tests have been created using shinytest2 and testthat in the `tests/testthat/` folder. They test that the app loads, and give examples of UI, server and function tests (for example the value boxes, dropdown filtering and `in_line_nav_link()`). You should edit the tests as you add new features into the app and continue to add and maintain the tests over time.

GitHub Actions provide continuous integration (CI) by running the automated tests, lintr checks and Air formatting checks on pull requests. These workflows (`automated-tests.yaml`, `lint.yaml` and `air.yml`) call the reusable workflows maintained in the [dfeshiny repository](https://github.com/dfe-analytical-services/dfeshiny), and can be found in the .github/workflows folder.

You should run `shinytest2::test_app()` regularly to check that the tests are passing against the code you are working on.

### Deployment

The app is deployed to Department for Education's shinyapps.io subscription using GitHub actions. The `.github/workflows/deploy-shiny.yaml` workflow runs on pushes to the main and development branches and calls the dfeshiny dashboard deploy template, which reads the dashboard name and deploy target from `deploy-parameters.yaml`. Maintenance of this is provided by the Explore education statistics platforms team.

The `manifest.json` file records the app's files and package versions for deployment. It is rebuilt with `rsconnect::writeManifest()` by the pre-commit hook, so keep it in step with `renv.lock`.

### Pre-commit hooks

The `.Rprofile` copies `.hooks/pre-commit.R` into `.git/hooks/` each time the project is opened. Before each commit, the hook:

1. Checks that every data file is recorded in `datafiles_log.csv` and that any unpublished data is listed in `.gitignore`, aborting the commit if not
2. Replaces the template's Google Analytics tag with a placeholder
3. Rebuilds `manifest.json` using rsconnect

### Navigation

In general all .r files will have a usable outline, so make use of that for navigation if in RStudio: `Ctrl-Shift-O`.

### Code styling 

Code formatting is checked by [Air](https://posit-dev.github.io/air/) on every pull request. Format your code with Air regularly (it is built into Positron and can be run from the command line using `air format .`), as only formatted code will pass the checks. The function `styler::style_dir()` can also be used to tidy code according to tidyverse styling and to catch basic syntax errors such as missing commas and brackets.

You should also run `lintr::lint_dir()` regularly as lintr will check all pull requests for the styling of the code, it does not style the code for you like styler, but is slightly stricter and checks for long lines, variables not using snake case, commented out code and undefined objects amongst other things.

---

## How to contribute

We welcome all suggestions and contributions to this template, and recommend [raising an issue in GitHub](https://github.com/dfe-analytical-services/shiny-template/issues/new/choose) to start discussions around potential additions or changes with the maintaining team.

### Flagging issues

If you spot any issues with the application, please flag it in the [issues tab of this repository](https://github.com/dfe-analytical-services/shiny-template/issues), and label as a bug. Include as much detail as possible to help the developers diagnose the issue and prepare a suitable remedy.

### Making suggestions

You can also use the [issues tab of this repository](https://github.com/dfe-analytical-services/shiny-template/issues) to suggest new features, changes or additions. Include as much detail on why you're making the suggestion and any thinking towards a solution that you have already done.

---

## Contact

explore.statistics@education.gov.uk
