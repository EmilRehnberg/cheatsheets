## ---- forcats-pkg-installation
devtools::install_github("tidyverse/forcats")

## ---- gss_cat-data
data("gss_cat", package = "forcats")
gss_cat

## ---- forcats-pkg-quick-demo
data("starwars", package = "dplyr")

# combining small factors
starwars %>%
  dplyr::filter(!is.na(species)) %>%
  dplyr::count(species, sort = TRUE)

starwars %>%
  dplyr::filter(!is.na(species)) %>%
  dplyr::mutate(species = forcats::fct_lump(species, n = 3)) %>%
  dplyr::count(species)

# reorder factor levels according to frequency
starwars %>%
  ggplot2::ggplot(ggplot2::aes(x = eye_color)) +
  ggplot2::geom_bar() +
  ggplot2::coord_flip()

starwars %>%
  dplyr::mutate(eye_color = forcats::fct_infreq(eye_color)) %>%
  ggplot2::ggplot(ggplot2::aes(x = eye_color)) +
  ggplot2::geom_bar() +
  ggplot2::coord_flip()

## ---- forcats-pkg-cross-demo
fruit <- factor(c("apple", "kiwi", "apple", "apple"))
colour <- factor(c("green", "green", "red", "green"))
forcats::fct_cross(fruit, colour)

## ---- forcats-pkg-lump-min-demo
x <- factor(letters[rpois(50, 3)])
forcats::fct_lump_min(x, min = 5)
forcats::fct_lump(x, n = 5) # unclear how this is any different

## ---- forcats-pkg-matching-demo
data("gss_cat", package = "forcats")
gss_cat$marital %>% forcats::fct_match(c("Married", "Divorced")) %>% table()

# Shows errors if there's unexpected levels
gss_cat$marital %in% c("Maried", "Davorced") %>% table() # same as `magrittr::is_in()`
gss_cat$marital %>% forcats::fct_match(c("Maried", "Davorced")) %>% table()

## ---- forcats-pkg-relevel-demo
f <- factor(c("a", "b", "c", "d"), levels = c("b", "c", "d", "a"))
forcats::fct_relevel(f)
forcats::fct_relevel(f, "a")
forcats::fct_relevel(f, "b", "a")

# Move to the third position
forcats::fct_relevel(f, "a", after = 2)

# Relevel to the end
forcats::fct_relevel(f, "a", after = Inf)
forcats::fct_relevel(f, "a", after = 3)

# Relevel with a function
forcats::fct_relevel(f, sort)
forcats::fct_relevel(f, sample)
forcats::fct_relevel(f, rev)

## ---- forcats-pkg-as_factor-demo
y <- c("1.1", "11", "2.2", "22")
y %>% forcats::as_factor()
# Note the factor level sorting on numeric size when numeric
y %>% as.numeric() %>% forcats::as_factor()
