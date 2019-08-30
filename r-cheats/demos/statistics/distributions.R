# ---- shape-demo-dependecies ----
devtools::install_github("cran/PearsonDS")
# ---- skewness-randomize ----
non_skewed_moments <- c(mean = 0, variance = 1, skewness = 0, kurtosis = 3)
skewed_moments <- c(mean = 0, variance = 1, skewness = 1.5, kurtosis = 4)
PearsonDS::rpearson(1000, moments = non_skewed_moments) %>%
  ggpubr::gghistogram() + ggplot2::ggtitle("Non Skewed")

PearsonDS::rpearson(1000, moments = skewed_moments) %>%
  ggpubr::gghistogram() + ggplot2::ggtitle("Skewed")

# ---- kurtosis-randomize ----
kurtosis_moments <- c(mean = 0, variance = 1, skewness = 0, kurtosis = 4)
PearsonDS::rpearson(1000, moments = kurtosis_moments) %>%
  ggpubr::gghistogram() + ggplot2::ggtitle("with excess kurtosis")
