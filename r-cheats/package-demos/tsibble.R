# ---- dependecies ----
devtools::install_github("tidyverts/tsibble")

# ---- tsibble-demo ----

sdd <-
  data.frame(
    state = "delaware",
    city = rep(c("city 1", "city 2"), 2),
    time_stamp = c("2000-01-01 00:00:00", "2000-01-01 00:00:02", "2000-01-01 00:00:04", "2000-01-01 00:00:06"),
    sensor = 1:4,
    stringsAsFactors = FALSE
  ) %>%
  dplyr::mutate_at("time_stamp", as.POSIXct) %>%
  tsibble::as_tsibble(index = "time_stamp", key = "city")

sdd$time_stamp %>% tsibble::interval_pull()
tsibble::yearquarter(c("2000 Q1", "2000 Q2", "2000 Q3", "2000 Q4", "2001 Q1")) %>% tsibble::interval_pull()
sdd %>% tsibble::index()
sdd %>% tsibble::index_var()
sdd %>% tsibble::interval()
sdd %>%
  tsibble::index() %>%
  class()
sdd %>%
  tsibble::index_var() %>%
  class()
sdd %>%
  tsibble::interval() %>%
  class()

sdd %>% tsibble::n_keys()
sdd %>% tsibble::key()
sdd %>% tsibble::key_data()
sdd %>% tsibble::key_vars()
sdd %>% tsibble::key_rows()

sdd %>% tsibble::measures()
sdd %>% tsibble::measured_vars()

sdd %>% tsibble::append_case()
