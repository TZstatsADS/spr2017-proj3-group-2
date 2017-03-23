#####################cross validate the best number of iterations#####################

#iter <- seq(60,100,by=10)
#iter is the range of the tune parameters
CNNcv <- function(iter){
errorvec <- matrix(NA,nrow = length(iter),ncol = 2)

index <- sample(rep(1:5,each = nrow(train)/5),replace = F)


j <- 1
for(i in iter)
{
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

return(paste("the best parameter is:",para))
}
#######################################################