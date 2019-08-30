## ---- dplyr::installation
devtools::install_github("tidyverse/dplyr")

## ---- starwars-data
data("starwars", package = "dplyr")
starwars

## ---- band_members-data
data(band_members, package = "dplyr")
band_members

## ---- band_instruments-data
data(band_instruments, package = "dplyr")
band_instruments

## ---- dplyr::group_map-demo
# the keys are exposed as ".y"!
iris %>%
  dplyr::group_by(Species) %>%
  dplyr::group_map(~ quantile(.x$Petal.Length, probs = c(0.25, 0.5, 0.75)))

mtcars %>%
  dplyr::group_by(cyl) %>%
  dplyr::group_map(~ head(.x, 2L))

mtcars %>%
  dplyr::group_by(cyl) %>%
  dplyr::group_map(~ dplyr::tibble(mod = list(lm(mpg ~ disp, data = .x))))

## ---- dplyr::group_modify-demo
iris %>%
  dplyr::group_by(Species) %>%
  dplyr::group_modify(~ {
     quantile(.x$Petal.Length, probs = c(0.25, 0.5, 0.75)) %>%
     tibble::enframe(name = "prob", value = "quantile")
  })

## ---- dplyr::group_walk-demo
# group_walk() is for side effects
dir.create(temp <- tempfile())
iris %>%
dplyr::group_by(Species) %>%
dplyr::group_walk(~ write.csv(.x, file = file.path(temp, paste0(.y$Species, ".csv"))))
list.files(temp, pattern = "csv$")
unlink(temp, recursive = TRUE)

## ---- dplyr::column-wise-functions
# dplyr::vars expands the columns in dta
to_inch <- function(dta, ...) {
  inch <- 0.393701 # can be used in the lambda
  dta %>% dplyr::mutate_at(dplyr::vars(...), ~ . * inch)
}
iris %>%
  dplyr::as_tibble() %>%
  to_inch(-Species)

# only operate the function on columns starting with "Sepal"
iris %>%
  dplyr::as_tibble() %>%
  dplyr::mutate_at(dplyr::vars(dplyr::starts_with("Sepal")), ~ . / Petal.Width)

## ---- dplyr::count-demo
df <- dplyr::tibble(
  f1 = factor(c("a", "a", "a", "b", "b"), levels = c("a", "b", "c")),
  f2 = factor(c("d", "e", "d", "e", "f"), levels = c("d", "e", "f")),
  x  = c(1, 1, 1, 2, 2),
  y  = 1:5
)
df %>% dplyr::count(f1) # I though .drop = FALSE was default but not on my system ATM..
df %>% dplyr::count(f1, .drop = FALSE)
df %>% dplyr::count(f1, f2, .drop = FALSE)

df %>%
  dplyr::group_by(x, f1) %>%
  dplyr::summarise(avg = mean(y))
df %>%
  dplyr::group_by(x, f1, .drop = FALSE) %>%
  dplyr::summarise(avg = mean(y))

## ---- dplyr::group_trim-demo
iris %>%
  dplyr::group_by(Species) %>%
  dplyr::filter(stringr::str_detect(Species, "^v")) %>% # match factors starting with v
  dplyr::ungroup() %>%
  dplyr::group_by(Species = forcats::fct_drop(Species)) # to drop empty factors
# alternatively use dplyr::group_trim
iris %>%
  dplyr::group_by(Species) %>%
  dplyr::filter(stringr::str_detect(Species, "^v")) %>%
  dplyr::group_trim()

## ---- dplyr::grouping-fuctions
data <- iris %>%
  dplyr::group_by(Species) %>%
  dplyr::filter(Sepal.Length > mean(Sepal.Length))
 
data %>% dplyr::group_nest()
data %>% dplyr::group_split()
data %>% dplyr::group_keys()
data %>% dplyr::group_rows()

# alternatively ungrouped data frame, together with a grouping specification
iris %>% dplyr::group_nest(Species)
iris %>% dplyr::group_split(Species)
iris %>% dplyr::group_keys(Species)

## ---- dplyr::nest_join-demo
# a prestage to other joins. similar to an inner join
band_members %>% dplyr::nest_join(band_instruments)

## ---- dplyr::purr-style-scoped-verbs
iris %>%
  dplyr::as_tibble %>%
  dplyr::mutate_if(is.numeric, ~ . - mean(.)) # subtract mean
# or with purrr-style lambda

fns <- list(
  centered = mean,
  scaled = ~ . - mean(.) / sd(.)
)
iris %>%
  dplyr::as_tibble %>%
  dplyr::mutate_if(is.numeric, fns)

## ---- dplyr::group_cols-helper
mtcars %>%
  dplyr::group_by(cyl) %>%
  dplyr::select(dplyr::group_cols())
# It makes it easy to remove explicitly the grouping variables
mtcars %>%
  dplyr::group_by(cyl) %>%
  dplyr::mutate_at(
    dplyr::vars(dplyr::starts_with("c"), -dplyr::group_cols()),
    ~ . - mean(.)
  )
