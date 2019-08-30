## ---- forecast-pkg-dependencies
# Dependency packages are `forecast` and `mgcv`
dependencies <- c("timeDate", "quadprog", "TTR", "quantmod", "tseries", "fracdiff", "RcppArmadillo", "forecast")
remotes::install_github(paste("cran", dependencies, sep = "/"))
remotes::install_github("robjhyndman/forecast")
remotes::install_github("robjhyndman/fpp2-package")
remotes::install_github("r-lib/svglite")
remotes::install_github("kassambara/ggpubr")

## ---- forecast-pkg-demo
x <-
  rpois(100, 1 + sin(seq(0, 3 * pi, length.out = 100))) %>%
  ts(frequency = 12)
tt <- 1:100
(season <- x %>% forecast::seasonaldummy()) %>% head()

fit <- mgcv::gam(x ~ s(tt, k = 5) + season,
  family = "poisson"
)
fit %>% plot()
fit %>% summary()

fcast <-
  predict(fit,
    se.fit = TRUE,
    newdata = list(
      tt = 101:112,
      season = forecast::seasonaldummy(x, h = 12)
    )
  )

x %>% plot(xlim = c(0, 10.5))
fcast$fit %>%
  exp() %>%
  stats::ts(frequency = 12, start = 112 / 12) %>%
  lines(col = 2)
fcast %>%
  {
    .$fit - 2 * .$se.fit
  } %>%
  exp() %>%
  stats::ts(frequency = 12, start = 112 / 12) %>%
  lines(col = 2, lty = 2)
fcast %>%
  {
    .$fit + 2 * .$se.fit
  } %>%
  exp() %>%
  ts(frequency = 12, start = 112 / 12) %>%
  lines(col = 2, lty = 2)

# ---- ts-autoplot ----
ggplot2::autoplot(fpp2::melsyd[, "Economy.Class"]) +
  ggplot2::ggtitle("MelSyd") + ggplot2::ylab("Economy Class")

# ---- ts-window ----
window(fpp2::ausbeer, start = 1992) %>% forecast::gglagplot()

# ---- ts-residual-acf ----
library(forecast)
forecast::ggAcf(window(fpp2::ausbeer, start = 1992))

# ---- ts-residual-acf-elec ----
ggplot2::autoplot(window(fma::elec, start = 1980)) + ggplot2::xlab("Year") + ggplot2::ylab("GWh")
forecast::ggAcf(window(fma::elec, start = 1980), lag = 48)

# ---- ts-residual-acf-white-noise ----
set.seed(30)
wn <- ts(rnorm(50))
ggplot2::autoplot(wn) + ggplot2::ggtitle("White noise")
forecast::ggAcf(wn)

# ---- ts-box-cox-transformation ----
ggplot2::autoplot(fma::elec)
ggplot2::autoplot(forecast::BoxCox(fma::elec, forecast::BoxCox.lambda(fma::elec)))

# ---- ts-forecasting-bias-adjustment ----
fc_med <- forecast::rwf(fma::eggs, drift = TRUE, lambda = 0, h = 50, level = 80)
fc_mean <- forecast::rwf(fma::eggs, drift = TRUE, lambda = 0, h = 50, level = 80, biasadj = TRUE)
ggplot2::autoplot(fma::eggs) +
  ggplot2::autolayer(fc_med, series = "Ord back transf (median)") +
  ggplot2::autolayer(fc_mean, series = "Bias Adj(mean)", PI = FALSE) +
  ggplot2::guides(colour = ggplot2::guide_legend(title = "Forecasts"))

# ---- goog200-naive-forecast ----
goog200_res <- fpp2::goog200 %>%
  forecast::naive() %>%
  stats::residuals()
ggplot2::autoplot(goog200_res) +
  ggplot2::ggtitle("goog200") + ggplot2::xlab("Day") + ggplot2::ylab("Naive Residuals")
ggpubr::gghistogram(goog200_res) + ggplot2::ggtitle("goog200 residuals")
goog200_res %>% forecast::ggAcf() + ggplot2::ggtitle("goog200 Naive Residuals ACF")
