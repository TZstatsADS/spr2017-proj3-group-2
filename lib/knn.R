### Author: Ka Heng (Helen) Lo
### Project 3
### ADS Spring 2017

#############================  Description  ================#############
##This file contains two functions:
#   1) Function to tune parameters of knn model with input set of features 
#      of training images
#   2) Function to train data to fit knn model given the 'best' params from 
#      tuning via cross-validation 
#########################################################################


require(e1071)
require(data.table)
require(class)



#tune parameter k for KNN classification via 10-fold cross-validation
tune.knn <- function(dat_train,label_train){
  label_train <- as.factor(label_train)
  obj <- tune.knn(dat_train,label_train,k=1:5)
  best_k <- obj$best.parameters[[1]]
  best_err <- obj$best.performance

  summary.knn <- data.table(Model = "KNN",
                            Best_Param_1 = paste("k =",best_k),
                            Best_Param_2 = NA, Best_Param_3 = NA,
                            Best_Error = best_err,
                            Training_Time = NA)
  #save(summary.knn, file="output/summary_best_knn.Rdata")
  return(summary.knn)
}

train.knn <- function(dat_train,label_train){
  label_train <- as.factor(label_train)
  best_k <- 1 #best parameter after tuning with 10-fold cross-validation
  return(best_k) #nothing to train for knn 
}