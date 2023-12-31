% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_project.R
\name{create_project}
\alias{create_project}
\title{Create a new TidyTuesday project}
\usage{
create_project(project_directory_base, tidytuesdayYear, tidytuesdayWeek, ...)
}
\arguments{
\item{project_directory_base}{The base directory where the new project will be created.}

\item{tidytuesdayYear}{The year of the TidyTuesday project.}

\item{tidytuesdayWeek}{The week number of the TidyTuesday project.}
}
\description{
This function initializes a new project directory with a specific structure for TidyTuesday analyses. It creates a README file, sets up directories for output, data, and analysis, and initializes a Quarto document with the specified week's TidyTuesday data loading code in the boilerplate content.
}
