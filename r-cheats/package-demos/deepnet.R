## ---- deepnet-installation
devtools::install_github("cran/deepnet")

## ---- deepnet-pkg-example-setup
# only works with matrices!!
# obsEach <- 50
# x <- data.frame(var1 = c(rnorm(obsEach, 1, 0.5), rnorm(obsEach, -0.6, 0.2))
#                 ,var2 = c(rnorm(obsEach, -0.8, 0.2), rnorm(obsEach, 2, 1)))
# y <- c(rep(1, obsEach), rep(0, obsEach))

Var1 <- c(rnorm(50, 1, 0.5), rnorm(50, -0.6, 0.2))
Var2 <- c(rnorm(50, -0.8, 0.2), rnorm(50, 2, 1))
x <- matrix(c(Var1, Var2), nrow = 100, ncol = 2)
y <- c(rep(1, 50), rep(0, 50))

test_Var1 <- c(rnorm(50, 1, 0.5), rnorm(50, -0.6, 0.2))
test_Var2 <- c(rnorm(50, -0.8, 0.2), rnorm(50, 2, 1))
test_x <- matrix(c(test_Var1, test_Var2), nrow = 100, ncol = 2)
test_y <- y

## ---- deepnet-pkg-training-nn
nn <- deepnet::nn.train(x, y, hidden = c(5)) # Check out the help!
deepnet::nn.test(nn, test_x, test_y) # returns error rate for classification

## ---- deepnet-pkg-deep-belief-nn
dbDnn <- deepnet::dbn.dnn.train(x, y, hidden = c(5, 5)) # check help!

## predict by dbDnn
# Test new samples by Trainded NN,return error rate for classification
deepnet::nn.test(dbDnn, test_x, test_y)

## ---- deepnet-pkg-stacked-autoencoder-nn
saeDnn <- deepnet::sae.dnn.train(x, y, hidden = c(5, 5)) # check help!

## predict by saeDnn
# Test new samples by Trainded NN,return error rate for classification
deepnet::nn.test(saeDnn, test_x, test_y)

## ---- deepnet-pkg-nn-predict
nnYPred <- deepnet::nn.predict(nn, test_x) %>% round(3)
dbDnnYPred <- deepnet::nn.predict(dbDnn, test_x) %>% round(4)
saeDnnYPred <- deepnet::nn.predict(saeDnn, test_x) %>% round(5)

# weight initialzer prediction comparisons
table(nnYPred, dbDnnYPred)
table(nnYPred, saeDnnYPred)
table(dbDnnYPred, saeDnnYPred)
