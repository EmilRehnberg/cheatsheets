## ---- autoencoder-pkg-installation
devtools::install_github("cran/autoencoder")

## ---- autoencoder-pkg-training-matrix-data
data('training_matrix_N=5e3_Ninput=100' ## the matrix contains 5e3 image
     ,package = "autoencoder")          ## patches of 10 by 10 pixels

## ---- autoencoder-pkg-example-setup
nl=3                          ## number of layers (default is 3: input, hidden, output)
unit.type = "logistic"        ## specify the network unit type, i.e., the unit's
                              ## activation function ("logistic" or "tanh")
Nx.patch=10                   ## width of training image patches, in pixels
Ny.patch=10                   ## height of training image patches, in pixels
N.input = Nx.patch*Ny.patch   ## number of units (neurons) in the input layer (one unit per pixel)
N.hidden = 10*10              ## number of units in the hidden layer
lambda = 0.0002               ## weight decay parameter
beta = 6                      ## weight of sparsity penalty term
rho = 0.01                    ## desired sparsity parameter
epsilon <- 0.001              ## a small parameter for initialization of weights
                              ## as small gaussian random numbers sampled from N(0,epsilon^2)
max.iterations = 2000         ## number of iterations in optimizer

## ---- autoencoder-pkg-example-run
# WARNING: the training can take a long time (~1 hour) for this dataset!
autoencoder.object <-
  autoencoder::autoencode( # check help
    X.train=training.matrix
    ,nl=nl
    ,N.hidden=N.hidden
    ,unit.type=unit.type
    ,lambda=lambda
    ,beta=beta
    ,rho=rho
    ,epsilon=epsilon
    ,optim.method="BFGS"
    ,max.iterations=max.iterations
    ,rescale.flag=TRUE
    ,rescaling.offset=0.001
    )

## ---- autoencoder-pkg-example-report-MSE
cat("autoencode(): mean squared error for training set: ",
round(autoencoder.object$mean.error.training.set,3),"\n")

## ---- autoencoder-pkg-example-extract-weights-biases
W <- autoencoder.object$W
b <- autoencoder.object$b

## ---- autoencoder-pkg-example-visualize-hidden-units
autoencoder::visualize.hidden.units(autoencoder.object,Nx.patch,Ny.patch)
