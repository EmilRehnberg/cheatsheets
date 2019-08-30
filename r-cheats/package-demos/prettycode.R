## ---- prettycode-pkg-installation
remotes::install_github("r-lib/prettycode")
## ---- prettycode-pkg-prettycode-function
# colorizes code in the terminal
f <- function() {
  ## A simple function
  print("Hello World!")

  seq(1, 10, by = 2)
}
prettycode::prettycode()
f
