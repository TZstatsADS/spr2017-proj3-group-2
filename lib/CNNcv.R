#####################cross validate the best number of iterations#####################
 
#iter <- seq(60,100,by=10)
#iter is the range of the tune parameters
CNNcv <- function(train,iter){
  errorvec <- matrix(NA,nrow = length(iter),ncol = 2)
  index <- sample(rep(1:5,each = nrow(train)/5),replace = F)
  
  #set the value for the parameters: symbol (=NN_model) and ctx (=devices)
  #to be passed to mx.model.FeedForward.create() later
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
  
  j <- 1
  for(i in iter){
    error <- c()
    for(k in 1:5){
      subtrain <- (data.matrix(train))[index!=k,]
      train_x1 <- t(subtrain[, -1])
      train_y1 <- subtrain[, 1]
      train_array1 <- train_x1
      dim(train_array1) <- c(28, 28, 1, ncol(train_x1))

      subcv <- (data.matrix(train))[index==k,]
      test_x1 <- t(subcv[, -1])
      test_y1 <- subcv[, 1]
      test_array1 <- test_x1
      dim(test_array1) <- c(28, 28, 1, ncol(test_x1))

      model <- mx.model.FeedForward.create(NN_model,
                                           X = train_array1,
                                           y = train_y1,
                                           ctx = devices,
                                           num.round =i,
                                           array.batch.size = 40,
                                           learning.rate = 0.01,
                                           momentum = 0.9,
                                           eval.metric = mx.metric.accuracy,
                                           epoch.end.callback = mx.callback.log.train.metric(100))
      predicted <- predict(model, test_array1)
      # Assign labels
      predicted_labels <- max.col(t(predicted)) - 1
      # Get accuracy
      error[k] <- sum(diag(table(test_y1, predicted_labels)))/length(test_y1)
    }
    errorvec[j,1] <- i
    errorvec[j,2] <- mean(error)
    j <- j+1
  }
  para<- errorvec[which.max(errorvec[,2]),1]
  cat("The best num.rounds is:", para)
  return(para)
}
#######################################################