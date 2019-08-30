# ---- prophet-pkg-dependencies  ----
remotes::install_github("cran/prophet") # facebook/prophet doesn't work?

# ---- prophet-pkg-usage ----
pmd <- read.csv("https://raw.githubusercontent.com/facebook/prophet/master/examples/example_wp_log_peyton_manning.csv")
p_mod <- prophet::prophet(pmd)
pmd_future <- prophet::make_future_dataframe(p_mod, periods = 365)
pmd_future %>% str()
pmd_future %>% tail()
pmd_forecast <- predict(p_mod, pmd_future)
pmd_forecast %>% str()
pmd_forecast %>% head()
plot(p_mod, pmd_forecast)
prophet::prophet_plot_components(p_mod, pmd_forecast)
