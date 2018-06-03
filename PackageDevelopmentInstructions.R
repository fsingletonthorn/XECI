# Creating a package 
# adapted from https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/
install.packages("devtools")
library("devtools")
devtools::install_github("klutometis/roxygen")
library(roxygen2)

# setwd to the place you want to create a package e.g., 
setwd("C:/Users/fsingletonthorn/Documents/XECI_repo")
create("XECI")

# Then Write and place functions in the [packagename]/R file - e.g., "C:/Users/fsingletonthorn/Documents/XECI_repo/XECI/R"
# Then set wd to the pacakge directory e.g.;
setwd("./XECI")
# and then run document() in order to automatically generate descriptions from the .R function file if appropriatly set up 
document()

