## ---- dbplyr-pkg-installation
devtools::install_github("tidyverse/dbplyr")

## ---- dbplyr-pkg-quick-demo
(con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:"))
dplyr::copy_to(con, mtcars)
(mtcars2 <- dplyr::tbl(con, "mtcars"))
# lazily generates query
summary <- mtcars2 %>%
  dplyr::group_by(cyl) %>%
  dplyr::summarise(mpg = mean(mpg, na.rm = TRUE)) %>%
  dplyr::arrange(desc(mpg)) # don't use dplyr::desc

# see query
summary %>% dplyr::show_query()

# execute query and retrieve results
summary %>% dplyr::collect()
