# From https://tinyheero.github.io/jekyll/update/2015/07/26/making-your-first-R-package.html

# 1. Set your working directory to where you want to create the package.
setwd("..")

# 2. Run the following to set up the package. Then, enter the package
package_name <- "reproducing-redlining"
devtools::create(package_name)
setwd(package_name)


# 3. Edit DESCRIPTION with your name, description, license, and the dependencies required

# 4. Write code and place in R folder. Generally want to put each function in its own .R file. You can also add data to the package itself with the following lines (just uncomment):

#x <- c(1:10)
#devtools::use_data(x)

# 5. Generate documentation automatically using roxygen. Documentation looks like this:

#' Subheader of your function.
#'
#' More in-depth detailed description of your function.
#'
#' @param name Description of the parameter.
#' @export

# Then run the following to generate documentation automatically

devtools::document()

# You can also add vignettes to provide tutorials of the package's use like so:

usethis::use_vignette("introduction")

# 6. Install package locally and test

devtools::install()


# 7. Create unit tests to ensure the code works correctly!
