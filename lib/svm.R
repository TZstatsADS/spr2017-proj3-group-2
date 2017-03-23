### Author: Ka Heng (Helen) Lo
### Project 3
### ADS Spring 2017
#############================  Description  ================#############
##This file contains four functions:
#   1) Function to tune parameters of svm model with linear kernel with 
#      input set of features of training images
#   2) Function to train data to fit svm model with linear kernel given the 
#      'best' params from tuning via cross-validation 
#   3) Function to tune parameters of svm model with RBF kernel with 
#      input set of features of training images
#   4) Function to train data to fit svm model with RBF kernel given the 
#      'best' params from tuning via cross-validation 
#########################################################################

require(e1071)
require(data.table)


#Call this function to reproduce process of tuning params for svm model with linear kernel
# -- Returns a summary data.table object that details best parameters used 
#    based on training images and also saves the object in a .RData file 
tune.svm.lin <- function(dat_train,label_train){
  label_train <- as.factor(label_train)
  #Tune SVM with linear kernel w/ 10-fold CV; to find best params
  set.seed(8076)
  cv.out.lin <- tune.svm(dat_train,label_train,kernel="linear",
                           cost=c(5e3,1e4,5e4,1e5))
  best_params_lin <- as.list(cv.out.lin$best.parameters)
  best_params_lin <- best_params_lin[1]
  #best_params_lin #return list of best parameters 
  
  
  #train best SVM model with linear kernel from training images
  run.time.lin <- system.time(svm.lin <- svm(dat_train,label_train, scale=F,
                                         params=best_params_lin, 
                                         kernel="linear"))
  run.time.lin <- round(run.time.lin[1],3)
  cat("Time for training SVM model with linear kernel: " ,run.time.lin, "s \n")
  
  summary.svm.lin <- data.table(Model = "SVM with linear kernel",
             Best_Param_1 = paste("cost =",best_params_lin$cost),
             Best_Param_2 = NA, Best_Param_3 = NA,
             Best_Error = cv.out.lin$best.performance,
             Training_Time = paste(run.time.lin, "s"))
  #save(summary.svm.lin, file="output/summary_best_svm_lin.Rdata")
  return(summary.svm.lin)
}



##if it's decided that svm with linear kernel is best candidate for advanced model
##then source this R file and call this function in train.R
train.svm.lin <-function(dat_train,label_train){
  label_train <- as.factor(label_train)
  #best_cost = 5000
  svm.lin <- svm(dat_train,label_train, scale=F,
                 cost=5000, 
                 kernel="linear")
  return(svm.lin)
}

############################################################################################

#Call this function to reproduce process of tuning params for svm model with linear kernel
# -- Returns a summary data.table object that details best parameters used 
#    based on training images and also saves the object in a .RData file 
tune.svm.rad <- function(dat_train,label_train){
  label_train <- as.factor(label_train)
  #Tune SVM with radial kernel w/ 10-fold CV
  set.seed(1681)
  cv.out.rad <- tune.svm(train_sift,train_labels,kernel="radial",cost=c(5e2,1e3,1e4),
           gamma=c(.5,1,2))
  best_params_rad <- list(cost=cv.out.rad$best.parameters$cost,
                          gamma=cv.out.rad$best.parameters$gamma)
  
  #train best SVM model with radial kernel

  run.time.rad <- system.time(svm.rad <- svm(dat_train,label_train, scale=F,
                                         params=best_params_rad,
                                         kernel="radial"))
  run.time.rad <- round(run.time.rad[1],3)
  cat("Time for training SVM model with radial kernel: " ,run.time.rad, "s \n")

  summary.svm.rad <- data.table(Model = "SVM with Radial Kernel",
             Best_Param_1 = paste("cost =",best_params_rad[[1]]),
             Best_Param_2 = paste("gamma =", best_params_rad[[2]]),
             Best_Param_3 = NA, Best_Error = cv.out.rad$best.performance,
             Training_Time = paste(run.time.rad, "s"))
  #save(summary.svm.rad,file="output/summary_best_svm_rad.Rdata")
  return(summary.svm.rad)
}  
#tune.svm.rad()


##if it's decided that svm with radial kernel is best candidate for advanced model
##then source this R file and call this function in train.R
train.svm.rad <- function(dat_train,label_train){
  label_train <- as.factor(label_train)
  best_params_rad <- list(cost=500,gamma=2)
  svm.rad <- svm(dat_train,label_train, scale=F,
                 params=best_params_rad,
                 kernel="radial")
  return(svm.rad)
}