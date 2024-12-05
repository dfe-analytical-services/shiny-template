# Department for Education template R Shiny application

---

## Introduction 

**Before using this template, please contact the Explore education statistics platforms team (explore.statistics@education.gov.uk) to discuss your plans for creating a DfE dashboard.**

This template repository is for making accessible apps for published statistics in DfE. It includes a basic shiny app with DfE styling and example components, as well as templates for additional best practice documents like the README script, pull request templates and codes of conduct for contributing.

This template app is deployed in the following places for you to view:

- Public production - https://department-for-education.shinyapps.io/dfe-shiny-template/
- Public overflow - https://department-for-education.shinyapps.io/dfe-shiny-template-overflow/

We have guidance on [creating public dashboards](https://dfe-analytical-services.github.io/analysts-guide/writing-visualising/dashboards.html) and [creating dashboards in R Shiny](https://dfe-analytical-services.github.io/analysts-guide/writing-visualising/dashboards_rshiny.html) that you should familiarise yourself with before using this template.

---

## Using this template

If you wish to begin developing an official DfE dashboard, then contact the explore education statistics platforms team to arrange a new dashboard repository based on this template in the dfe-analytical-services GitHub area. 

If you just want to experiment with the template first, you can create your own copy of the template by clicking the green "use this template" button. Though note that all DfE dashboards must be held within the dfe-analytical-services area and you should minimise any code that is held in personal repositories.

---

### New application checklist

---

Once you have a new repository set up from this template, you should start by taking the following actions. If you have any issues while running these please contact explore.statistics@gov.uk for support.

#### Check you can run it

1. Check that you can run the app successfully using the instructions in this README
2. Check that the example automated tests also run successfully using `shinytest2::test_app()`<br>
(If you get `Error in initialize(...) : Invalid path to Chrome`, the Analyst's Guide has a solution - [shinytest2 - Invalid path to Chrome (chromote) error message](https://dfe-analytical-services.github.io/analysts-guide/learning-development/r.html#shinytest2---invalid-path-to-chrome-chromote-error-message))

#### Update standard variables

3. Update the app title in the `ui.R` script and the `tests/testthat/test-UI-01-basic_load.R` UI test script
4. Update the rest of the app metadata set in the `ui.R` script
5. Update the variables set in the `global.R` script
6. Test that the app still loads okay in the tests using `shinytest2::test_app()`
7. Note: You may get a failure for the test in `test-UI-01-basic_load.R`, with a reason similar to `app$get_text("title") not equal to ...`. See this [workaround for the failure of the UI test](#ui-test-fail).

Finally before adding your own code, you should update the readme, deleting this version and then replacing with your own content applicable to your dashboard based on the README_template.md file in this repository. Once done you should also delete that template, leaving you with a single `README.md` file that documents an overview of your application. Continue to edit and maintain that as a key document for your application over time.

#### Set up other things

Before publishing there will be a number of other things you wish to set up. You can do some of these using the functions starting with `init_` from the `dfeshiny` package. More guidance on these steps, including walk-through guides can be found on the [dfeshiny package documentation site](https://dfe-analytical-services.github.io/dfeshiny/).

* User analytics using Google Analytics using `dfeshiny::init_analytics()`
* Cookies tracking using `dfeshiny::init_cookies()` and following the [guide to using the cookies functions in dfeshiny](https://dfe-analytical-services.github.io/dfeshiny/articles/implementing-cookies.html)
* Deployment keys, to deploy to shinyapps.io and make a dashboard public, you will need to contact explore.statistics@education.gov.uk for them to add the deployment keys as secure variables in your repository to then allow the `.github/workflows/deploy-shiny.yaml` workflow to run successfully

---

## Requirements

The following requirements are necessary for running the application yourself or contributing to it.

### i. Software requirements (for running locally)

- Installation of R Studio 2024.04.2+764 "Chocolate Cosmos" or higher

- Installation of R 4.4.1 or higher

- Installation of RTools44 or higher

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

All R code outside of the core `global.R`, `server.R`, and `ui.R` files is stored in the `R/` folder. There is a `utils.R` file for common custom functions, and scripts for the different UI panels in the `R/ui_panels/` folder.

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

Lines 49 to 68 in the `server.R` script are used to change the app title dependent on some selections.

Updating the app title in the `ui.R` script and the `tests/testthat/test-UI-01-basic_load.R` UI test script may lead to an error when `shinytest2::test_app()` is run. The error may look something similar to:

```
── Failed tests ──────────────────────────────────────────────────────────────────────────────────────────────────────────
Failure (test-UI-01-basic_load.R:30:3): App loads and title of app appears as expected
app$get_text("title") not equal to "Your new app title".
1/1 mismatches
x[1]: "Your new app title - All Local authority maintained schools, England"
y[1]: "Your new app title"
```

To fix / workaround this, please comment out or delete the lines 49 to 68 in the `server.R` script.

However, this feature can be helpful. For example, if you have lots of tabs / pages in your dashboard to switch the title depending on which one a user is looking at. But, its biggest value is for screen readers and assistive tech users, as they will get an announcement every time the title changes.
So, note this may be a useful feature for later on in your app development.

### Tests

Automated tests have been created using shinytest2 that test the app loads and also give other examples of ways you can use tests. You should edit the tests as you add new features into the app and continue to add and maintain the tests over time.

GitHub Actions provide continuous integration (CI) by running the automated tests and checks for code styling on every pull request into the main branch. The yaml files for these workflows can be found in the .github/workflows folder.

You should run `shinytest2::test_app()` regularly to check that the tests are passing against the code you are working on.

### Deployment

The app is deployed to Department for Education's shinyapps.io subscription using GitHub actions. The yaml file for this can be found in the .github/workflows folder. Maintenance of this is provided by the Explore education statistics platforms team.

### Navigation

In general all .r files will have a usable outline, so make use of that for navigation if in RStudio: `Ctrl-Shift-O`.

### Code styling 

The function `styler::style_dir()` will tidy code according to tidyverse styling using the styler package. Run this regularly as only tidied code will be allowed to be committed. This function also helps to test the running of the code and for basic syntax errors such as missing commas and brackets.

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
