## ---- neuralnet-installation
devtools::install_github("cran/ISLR")
devtools::install_github("cran/caTools")
devtools::install_github("cran/neuralnet")

## ---- neuralnet-pkg-demo
unitScale <- function(dta)
  scale(dta
        ,center = dta %>% purrr::map_dbl(min, na.rm = TRUE)
        ,scale = dta %>% purrr::map(range, na.rm = TRUE) %>% purrr::map_dbl(diff)
        )

scaledCollegeFeatures <-
  College %>% dplyr::select(-Private) %>% unitScale %>% as.data.frame %>%
    dplyr::mutate(Private = College$Private %>% as.numeric %>% subtract(1))

trainObsNumbers <- scaledCollegeFeatures %>% nrow %>% sample(., .*.2, replace = FALSE)

frml <-
  paste("Private ~"
        ,scaledCollegeFeatures %>% names %>% setdiff("Private") %>% paste(collapse = "+")
        ) %>% as.formula

# Applying neuralnet. Here with hidden set to 10 neurons for each of the 3 hidden layers.
nn <-
  neuralnet::neuralnet(frml # check the help
                       ,data = scaledCollegeFeatures[trainObsNumbers,]
                       ,hidden = c(10,10,10) # hidden neurons at each layer.
                       ,linear.output = FALSE
                       )

## ---- neuralnet-pkg-demo-plot
neuralnet::neuralnet("Private ~ Enroll + Top10perc + Outstate + Books + PhD + Terminal + Expend"
                     ,data = scaledCollegeFeatures[trainObsNumbers,]
                     ,hidden = c(4,3) # hidden neurons at each layer.
                     ,linear.output = FALSE
                     ) %>% plot

