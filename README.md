# Department for Education template R Shiny application

**Before using this template, please contact the Explore education statistics platforms team (explore.statistics@education.gov.uk) to discuss your plans for setting up a DfE dashboard.**

This template repository is for making accessible apps for published statistics in DfE. It includes a basic accessible shiny app with DfE styling, as well as templates for additional best practice documents like this README script, pull request templates and codes of conduct for contributing.

There is a version of this template hosted for you to preview at https://department-for-education.shinyapps.io/dfe-shiny-template/.

To use this template, click the green "use this template" button at the top of the repo. This will create a copy for you to work off of. 

Please delete this header section and all commented lines when you are writing up the README file for your own app.

Please contact explore.statistics@education.gov.uk if you have any questions, or raise an issue on here if you have spotted something specific that we should change.

---

## Introduction 

<!-- Give a brief overview of what your app is for here.-->

...

This application is deployed in the following places:

<!-- Update this list as appropriate for your app -->

- Public production - https://department-for-education.shinyapps.io/dfe-shiny-template/
- Public overflow - https://department-for-education.shinyapps.io/dfe-shiny-template-overflow/

---

## Requirements

The following requirements are necessarily for running the application yourself or contributing to it.

### i. Software requirements (for running locally)

<!-- Update these to match your application -->

- Installation of R Studio 2024.04.2+764 "Chocolate Cosmos" or higher

- Installation of R 4.4.1 or higher

- Installation of RTools44 or higher

### ii. Programming skills required (for editing or troubleshooting)

<!-- Update these to match your application -->

- R at an intermediate level, [DfE R leanring resources](https://dfe-analytical-services.github.io/analysts-guide/learning-development/r.html)

- Particularly [R Shiny](https://shiny.rstudio.com/)

### iii. Access requirements

<!-- Detail any access requirements, e.g. database access for source data, including what level of access is required and how to request it.-->

...
  
---

## How to use

<!-- Add any other useful detail for others about your application code here -->

...

### Running the app locally

1. Clone or download the repo. 

2. Open the R project in R Studio.

3. Run `renv::restore()` to install dependencies.

4. Run `shiny::runApp()` to run the app locally.

### Folder structure

All R code outside of the core `global.R`, `server.R`, and `ui.R` files is stored in the `R/` folder. There is a `utils.R` file for common custom functions, and scripts for the different UI panels in the `R/ui_panels/` folder.

<!-- Include any other detail as appropriate to help guide others around your repo -->

...

### Packages

Package control is handled using renv. As in the steps above, you will need to run `renv::restore()` if this is your first time using the project.

Whenever you add new packages, make sure to use `renv::snapshot()` to record them in the `renv.lock` file.

### Tests

Automated tests have been created using shinytest2 that test the app loads and also give other examples of ways you can use tests. You should edit the tests as you add new features into the app and continue to add and maintain the tests over time.

GitHub Actions provide CI by running the automated tests and checks for code styling on every pull request into the main branch. The yaml files for these workflows can be found in the .github/workflows folder.

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

<!-- Add any other ways to contribute to your application here -->

...

### Flagging issues

If you spot any issues with the application, please flag it in the "Issues" tab of this repository, and label as a bug. Include as much detail as possible to help the developers diagnose the issue and prepare a suitable remedy.

### Making suggestions

You can also use the "Issues" tab in GitHub to suggest new features, changes or additions. Include as much detail on why you're making the suggestion and any thinking towards a solution that you have already done.

---

## Contact

<!-- Add contact details of how to get in touch with your team. -->

...
