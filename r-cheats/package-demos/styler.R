## ---- styler-pkg-installation
remotes::install_github("r-lib/styler")
## ---- styler-pkg-simple-example
styler::style_text("a=function( x){1+1}")
# styler::style_file() styles .R and/or .Rmd files.
# styler::style_dir() styles all .R and/or .Rmd files in a directory.
# styler::style_pkg() styles the source files of an R package.
