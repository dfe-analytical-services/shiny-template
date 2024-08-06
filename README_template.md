<!-- This is a template README for a DfE dashboard, use this as a starting point for creating your own readme, making sure to replace or delete wherevere there is three dots (...) with the content appropriate for your dashboard -->

<!-- Add the title of your of application -->
# ... 

---

## Introduction 

<!-- Add a short 2-3 sentence description of what your application is for and why it exists -->
... 


This application is deployed in the following places:

<!-- Update this list as appropriate for your app -->

- ...
- ...
- ...

---

## Requirements

The following requirements are necessary for running the application yourself or contributing to it.

### i. Software requirements (for running locally)

<!-- Update these to match your application if they differ from the template -->

- Installation of R Studio 2024.04.2+764 "Chocolate Cosmos" or higher

- Installation of R 4.4.1 or higher

- Installation of RTools44 or higher

### ii. Programming skills required (for editing or troubleshooting)

<!-- Update these to match your application -->

- R at an intermediate level, [DfE R learning resources](https://dfe-analytical-services.github.io/analysts-guide/learning-development/r.html)

- Particularly [R Shiny](https://shiny.rstudio.com/)

### iii. Access requirements

<!-- Detail any access requirements, e.g. database access for source data, including what level of access is required and how to request it.-->

...
  
---

## How to use

<!-- Add any other useful detail for others about your application code here, target it at someone new to your team who might be contributing to the dashboard for the first time, what would you want them to know? -->

...

### Running the app locally

1. Clone or download the repo. 

2. Open the R project in R Studio.

3. Run `renv::restore()` to install dependencies.

4. Run `shiny::runApp()` to run the app locally.

### Folder structure

All R code outside of the core `global.R`, `server.R`, and `ui.R` files is stored in the `R/` folder. There is a `R/helper_functions.R` file for common custom functions, and scripts for the different UI panels in the `R/ui_panels/` folder.

<!-- Include any other detail or anything unique about your code structure as appropriate to help guide others around your repo -->

...

### Packages

Package control is handled using renv. As in the steps above, you will need to run `renv::restore()` if this is your first time using the project.

Whenever you add new packages, make sure to use `renv::snapshot()` to record them in the `renv.lock` file.

### Tests

Automated tests have been created using shinytest2 that test the app loads and also give other examples of ways you can use tests. You should edit the tests as you add new features into the app and continue to add and maintain the tests over time.

GitHub Actions provide CI by running the automated tests and checks for code styling on every pull request into the main branch. The yaml files for these workflows can be found in the .github/workflows folder.

You should run `shinytest2::test_app()` regularly to check that the tests are passing against the code you are working on.

### Deployment

The app is deployed to Department for Education's shinyapps.io subscription using GitHub actions. The yaml file for this can be found in the .github/workflows folder. Maintenance of this is provided by the explore education statistics platforms team.

### Navigation

In general all .r files will have a usable outline, so make use of that for navigation if in RStudio: `Ctrl-Shift-O`.

### Code styling 

The function `styler::style_dir()` will tidy code according to tidyverse styling using the styler package. Run this regularly as only tidied code will be allowed to be committed. This function also helps to test the running of the code and for basic syntax errors such as missing commas and brackets.

You should also run `lintr::lint_dir()` regularly as lintr will check all pull requests for the styling of the code, it does not style the code for you like styler, but is slightly stricter and checks for long lines, variables not using snake case, commented out code and undefined objects amongst other things.

---

## How to contribute

<!-- Add any other information or ways to contribute to your application here -->

...

### Flagging issues

If you spot any issues with the application, please flag it in the "Issues" tab of this repository, and label as a bug. Include as much detail as possible to help the developers diagnose the issue and prepare a suitable remedy.

### Making suggestions

You can also use the "Issues" tab in GitHub to suggest new features, changes or additions. Include as much detail on why you're making the suggestion and any thinking towards a solution that you have already done.

---

## Contact

<!-- Add contact details of how to get in touch with your team. The team mailbox is usually enough -->

...
