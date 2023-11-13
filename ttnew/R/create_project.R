#' Create a new TidyTuesday project
#'
#' This function initializes a new project directory with a specific structure for TidyTuesday analyses. It creates a README file, sets up directories for output, data, and analysis, and initializes a Quarto document with the specified week's TidyTuesday data loading code in the boilerplate content.
#'
#' @param project_directory_base The base directory where the new project will be created.
#' @param tidytuesdayYear The year of the TidyTuesday project.
#' @param tidytuesdayWeek The week number of the TidyTuesday project.
#' @export

create_project <- function(project_directory_base, tidytuesdayYear, tidytuesdayWeek, ...) {
  # Ensure year and week are integers
  tt_year <- as.integer(tidytuesdayYear)
  tt_week <- as.integer(tidytuesdayWeek)

  # Validate the inputs
  if (is.na(tt_year) || tt_year < 2000 || tt_year > 2100) {
    stop("Invalid year provided. Please enter a year between 2000 and 2100.")
  }
  if (is.na(tt_week) || tt_week < 1 || tt_week > 53) {
    stop("Invalid week number provided. Please enter a week number between 1 and 53.")
  }

  # Construct the directory name
  project_path <- project_directory_base

  # Create the project directory structure
  dir.create(project_path, recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(project_path, "output"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(project_path, "data"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(project_path, "analysis"), recursive = TRUE, showWarnings = FALSE)

  # Write the README.md file
  readme_lines <- c("# TidyTuesday Project", "", sprintf("This is a TidyTuesday project repository for the topic: %s", project_directory_base))
  writeLines(readme_lines, file.path(project_path, "README.md"))

  # Path to the template Quarto document
  template_path <- system.file("rstudio", "templates", "project", "notebook_template.qmd", package = "ttnew", mustWork = TRUE)


  # Read the template content
  template_content <- readLines(template_path)

  # Replace placeholders with actual values
  quarto_content <- gsub("\\{\\{year\\}\\}", tt_year, template_content)
  quarto_content <- gsub("\\{\\{week\\}\\}", sprintf("%02d", tt_week), quarto_content)
  quarto_content <- gsub("\\{\\{user_string\\}\\}", project_directory_base, quarto_content)


  # Write the Quarto document with the populated content
  writeLines(quarto_content, file.path(project_path, "analysis", "notebook.qmd"))

  # Optional: Other project configurations...

  # Return the full path of the new project directory
  return(project_path)
}
