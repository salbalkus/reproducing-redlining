# From https://www.r-bloggers.com/2019/11/automated-testing-with-testthat-in-practice/

test_that("Check commutative property", {
  expect_identical(4 + 6, 10)
  expect_identical(6 + 4, 10)
})

# Run the tests using the command test_dir("./path/to/folder")
# Examine the coverage of the tests using 
# covr <- package_coverage(path="./path/to/package")
# covr
# report(covr)