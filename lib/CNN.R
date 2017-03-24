#######if not install mxnet, run the following code#####
#install.packages("drat", repos="https://cran.rstudio.com")
#    drat:::addRepo("dmlc")
#    install.packages("mxnet")
##########

#img_dir <- "data/train/raw_images" #change to image directory
#label <- read.csv("data/train/labels.csv")
#label <- as.numeric(unlist(label))
to.rezise.split(img_dir,labels){ #note: labels are numerical values
  library(EBImage)
  library(stringr)
  require(mxnet)

  # This script is used to resize images to 28x28 pixels

  #img_dir <- "data/train/raw_images" #change to image directory
  n_files <- length(list.files(img_dir))
  #label <- read.csv("data/train/labels.csv")
  #label <- as.numeric(unlist(label))
  imgvec <- matrix(NA, ncol = 28*28,nrow = 2000)
  for(i in 1:n_files){
    ii <- str_pad(i, 4, pad = "0")
    img <- readImage(paste0(img_dir, "/","image_", ii,".jpg"))
    img1 <- resize(img,28,28)
    img1.scale <- img1/max(img1)
    img2 <- as.vector(img1)
    imgvec[i,] <- img2
  }

  # Train-test split
  set.seed(1)
  chitr <- sample(1:1000,900,replace = F)
  dogtr <- sample(1001:2000,900,replace = F)
  train.data <- imgvec[c(chitr,dogtr),]
  train.label <- label[c(chitr,dogtr)]
  test.data <- imgvec[-c(chitr,dogtr),]
  test.label <- label[-c(chitr,dogtr)]
  train <- data.frame(cbind(train.label,train.data))
  test <- data.frame(cbind(test.label,test.data))

  colnames(train) <- c("label", paste("pixel", c(1:784)))
  colnames(test) <- c("label", paste("pixel", c(1:784)))

  write.csv(train,"output/train_cnn.csv",row.names = F)
  write.csv(test,"output/test_cnn.csv",row.names = F)

  # Load train and test datasets
  train <- read.csv("train_cnn.csv",header = T)
  test <- read.csv("test_cnn.csv",header = T)
  output <- list(train_data = train,test_data = test)
  return(output)
  }


CNN <- function(train,test){
start.time <- Sys.time()
train <- data.matrix(train)
train_x <- t(train[, -1])
train_y <- train[, 1]
train_array <- train_x
dim(train_array) <- c(28, 28, 1, ncol(train_x))

test_x <- t(test[, -1])
test_y <- test[, 1]
test_array <- test_x
dim(test_array) <- c(28, 28, 1, ncol(test_x))


data <- mx.symbol.Variable('data')
# 1st convolutional layer
conv_1 <- mx.symbol.Convolution(data = data, kernel = c(5, 5), num_filter = 20)
tanh_1 <- mx.symbol.Activation(data = conv_1, act_type = "tanh")
pool_1 <- mx.symbol.Pooling(data = tanh_1, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
# 2nd convolutional layer
conv_2 <- mx.symbol.Convolution(data = pool_1, kernel = c(5, 5), num_filter = 50)
tanh_2 <- mx.symbol.Activation(data = conv_2, act_type = "tanh")
pool_2 <- mx.symbol.Pooling(data=tanh_2, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
# 1st fully connected layer
flatten <- mx.symbol.Flatten(data = pool_2)
fc_1 <- mx.symbol.FullyConnected(data = flatten, num_hidden = 500)
tanh_3 <- mx.symbol.Activation(data = fc_1, act_type = "tanh")
# 2nd fully connected layer
fc_2 <- mx.symbol.FullyConnected(data = tanh_3, num_hidden = 40)
# Output. Softmax output since we'd like to get some probabilities.
NN_model <- mx.symbol.SoftmaxOutput(data = fc_2)

# Set seed for reproducibility
mx.set.seed(100)
devices <- mx.cpu()


#retrain the model using best num.round parameter
model <- mx.model.FeedForward.create(NN_model,
                                     X = train_array,
                                     y = train_y,
                                     ctx = devices,
                                     num.round =60,
                                     array.batch.size = 40,
                                     learning.rate = 0.01,
                                     momentum = 0.9,
                                     eval.metric = mx.metric.accuracy,
                                     epoch.end.callback = mx.callback.log.train.metric(100))

predicted <- predict(model, test_array)
# Assign labels
predicted_labels <- max.col(t(predicted)) - 1
# Get accuracy
errorrate <- sum(diag(table(test[, 1], predicted_labels)))/200
end.time <- Sys.time()
runtime <- end.time-start.time
saveRDS(model,"summary_best_CNN.rds")
cat("the test error is:",errorrate,'\n',"the running time is:",runtime,"s")
ouput <- list(test_err = errorrate, train_time = runtime)
return(output)
}
