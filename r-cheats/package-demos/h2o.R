## ---- h2o-pkg-installation
"cran" %>% paste(c("RCurl", "jsonlite"), sep = "/") %>% devtools::install_github()
# dbl-check repo link by navigating the download site (in the h2o section).
install.packages(
  "h2o",
  type = "source",
  repos = "http://h2o-release.s3.amazonaws.com/h2o/rel-yates/3/R")

## ---- h2o-pkg-initialization
h2o::h2o.init(nthreads = 2, # use -1 to use all
              max_mem_size = "4g")

## ---- h2o-pkg-importing-data
#To import small iris data file from H2O’s package:
iris.hex <- h2o.importFile(
  path = system.file("extdata", "iris.csv", package="h2o")
  ,destination_frame = "iris.hex"
 )
iris.hex %>% (h2o::h2o.str)
iris.hex %>% as.data.frame %>% str
iris %>% str

#To import an entire folder of files as one data object:
# pathToFolder = "/Users/data/airlines/"
# airlines.hex = h2o.importFile(path = pathToFolder, destination_frame = "airlines.hex")

#To import from HDFS and connect to H2O in R using the IP and port of an H2O instance running on your Hadoop cluster:
 # h2o.init(ip= <IPAddress>, port =54321, nthreads = -1)
 # pathToData = "hdfs://mr-0xd6.h2oai.loc/datasets/airlines_all.csv"
 # airlines.hex = h2o.importFile(path = pathToData, destination_frame = "airlines.hex")

# Converts R object "iris" into H2O object "iris.hex"
iris.hex <- as.h2o(iris, destination_frame= "iris.hex")
head(iris.hex)

## ---- h2o-pkg-working-data
h2o::h2o.init()
airlines.hex <-
  h2o::h2o.importFile(path = "/tmp/allyears2k.csv" # From "https://s3.amazonaws.com/h2o-airlinesunpacked/allyears2k.csv"
                      ,destination_frame = "airlines.hex"
                      )
airlines.hex %>% class
airlines.hex %>% str
airlines.hex %>% summary

# View quantiles and histograms
quantile(x = airlines.hex$ArrDelay, na.rm = TRUE)
h2o::h2o.hist(airlines.hex$ArrDelay)

# Find number of flights by airport
originFlights <- airlines.hex %>%
  h2o::h2o.group_by(by = "Origin"
                    ,nrow("Origin")
                    ,gb.control=list(na.methods="rm")
                    )
# make the H2OFrame into a standard data.frame
# H2OFrames are worked on in the h2o framework, i.e. not your regular R-session environment.
originFlights %>% as.data.frame %>% str

# Find number of flights per month
(flightsByMonth <- airlines.hex %>%
  h2o::h2o.group_by(by = "Month"
                    ,nrow("Month")
                    ,gb.control=list(na.methods="rm"))
 )

# Find months with the highest cancellation ratio
cancellationsByMonth <- airlines.hex %>%
  h2o::h2o.group_by(by = "Month"
                    ,sum("Cancelled")
                    ,gb.control=list(na.methods="rm"))
cancellation_rate <- cancellationsByMonth$sum_Cancelled / flightsByMonth$nrow
rates_table <- h2o::h2o.cbind(flightsByMonth$Month, cancellation_rate)
rates_table %>% as.data.frame

# CONTRIBUTE
# >>>>.<<<<
# This is disgusting, how can the output list not be named >.<
# Construct test and train sets using sampling
airlines.split <- airlines.hex %>% h2o.splitFrame(ratios = 0.85)
airlines.train <- airlines.split[[1]]
airlines.test <- airlines.split[[2]]

# Display a summary using table-like functions
h2o::h2o.table(airlines.train$Cancelled)
h2o::h2o.table(airlines.test$Cancelled)

# CONTRIBUTE: the 'converting into factors' is atrocious, help out with this.


## ---- h2o-pkg-h2o.glm
# Define the data for the model and display the results
airlines.glm <- h2o::h2o.glm(
  training_frame=airlines.train
  , x=c("Origin", "Dest", "DayofMonth", "Year", "UniqueCarrier", "DayOfWeek", "Month", "DepTime", "ArrTime", "Distance")
  , y="IsDepDelayed"
  , family = "binomial"
  , alpha = 0.5
  )
# includes confusion matrix and a lot of stuff
print(airlines.glm)
# View model information: training statistics, performance, important variables
summary(airlines.glm)

# Predict using GLM model
airlines.test[,X]
pred <- h2o::h2o.predict(object = airlines.glm, newdata = airlines.test)
# Look at summary of predictions: probability of TRUE class (p1)
# CONTRIBUTE: the Booklet is incorrect
summary(pred)

# TODO: try to read results, they look funny.
# Questions: does the h2o.glm require a numeric outcome?
# the above uses regularization due to setting alpha, is standardization of the data required beforehand?

print(airlines.glm)
# Model Details:
# ==============

# H2OBinomialModel: glm
# Model ID:  GLM_model_R_1519091204698_3
# GLM Model: summary
#     family  link                                regularization number_of_predictors_total number_of_active_predictors
# 1 binomial logit Elastic Net (alpha = 0.5, lambda = 1.482E-4 )                        283                         174
#   number_of_iterations   training_frame
# 1                    6 RTMP_sid_ac2f_11

# Coefficients: glm coefficients
#       names coefficients standardized_coefficients
# 1 Intercept   124.608326                 -0.083354
# 2  Dest.ABE    -0.038939                 -0.038939
# 3  Dest.ABQ     0.619992                  0.619992
# 4  Dest.ACY     0.000000                  0.000000
# 5  Dest.ALB     0.000000                  0.000000

# ---
#          names coefficients standardized_coefficients
# 279      Month     0.043643                  0.082146
# 280 DayofMonth    -0.030185                 -0.276507
# 281  DayOfWeek     0.026462                  0.050342
# 282    DepTime     0.000799                  0.372481
# 283    ArrTime    -0.000070                 -0.033979
# 284   Distance     0.000269                  0.155981

# H2OBinomialMetrics: glm
# ** Reported on training data. **

# MSE:  0.2137609
# RMSE:  0.4623429
# LogLoss:  0.6163326
# Mean Per-Class Error:  0.3841098
# AUC:  0.7192129
# Gini:  0.4384258
# R^2:  0.1426972
# Residual Deviance:  45984.58
# AIC:  46334.58

# Confusion Matrix (vertical: actual; across: predicted) for F1-optimal threshold:
#          NO   YES    Error          Rate
# NO     6119 11576 0.654196  =11576/17695
# YES    2236 17374 0.114023   =2236/19610
# Totals 8355 28950 0.370245  =13812/37305

# Maximum Metrics: Maximum metrics at their respective thresholds
#                         metric threshold    value idx
# 1                       max f1  0.383832 0.715568 279
# 2                       max f2  0.111481 0.847229 388
# 3                 max f0point5  0.549731 0.681752 185
# 4                 max accuracy  0.529522 0.661520 197
# 5                max precision  0.978396 1.000000   0
# 6                   max recall  0.046384 1.000000 399
# 7              max specificity  0.978396 1.000000   0
# 8             max absolute_mcc  0.549731 0.324555 185
# 9   max min_per_class_accuracy  0.527486 0.660639 198
# 10 max mean_per_class_accuracy  0.549731 0.662039 185

# Gains/Lift Table: Extract with `h2o.gainsLift(<model>, <data>)` or `h2o.gainsLift(<model>, valid=<T/F>, xval=<T/F>)`

