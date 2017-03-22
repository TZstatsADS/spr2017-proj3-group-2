### Author: Ka Heng (Helen) Lo
### Project 3
### ADS Spring 2017
#############================  Description  ================#############
##This file contains two functions:
#   1) Function to tune parameters of xgboost model with input set of features 
#      of training images
#   2) Function to train data to fit xgboost model given the 'best' params from 
#      tuning via cross-validation 
#########################################################################

require(xgboost)
require(data.table)

#train_sift <- read.csv("data/train/sift_features.csv")
#train_sift <- t(as.matrix(train_sift))
#train_labels <- read.csv("data/train/labels.csv")
#train_labels <- as.matrix(train_labels)[,1]

#create xgb.DMatrix object for input (recommended)
#Dtrain_sift <- xgb.DMatrix(data=train_sift,label=train_labels)
#dim(Dtrain_sift)

##############################################################################

#Call this function to reproduce process of tuning params for xgb model via CV
# -- Returns a summary data.table object that details best parameters used 
#    based on training images and also saves the object in a .RData file 
tune.xgb <- function(dat_train,label_train){
  #create xgb.DMatrix object for input (recommended)
  Dtrain_sift <- xgb.DMatrix(data=dat_train,label=label_train)
  #set empty variables 
  best_params <- list() ; best_err <- Inf 
  best_nrounds <- NULL
  
  #cv.errors <- data.table(m1 = I(list()), m2 = I(list()), m3 = I(list()),
  #                        m4 = I(list()), m5 = I(list()))
  
  
  #nthread = number of parallel threads to use
  
  ##Control Overfitting:
  #Control model complexity
  #max_depth: [1,inf]
    #maximum depth of a tree; increasing this value makes model more complex
  #Add randomness to make training robust to noise 
  #eta: [0,1] #step size shrikage; makes boosting process more conservative 
  
  #vector of different max depth values of the tree (default = 6)
  depth_vals <- 4:8
  #vector of different eta values to control learning rate (default = 0.3) 
  eta_vals <- seq(.1,.5,.1)
  #for reproducible results 
  set.seed(77)
  for (i in 1:5){
    for (j in 1:5){
      my.params <- list(max_depth = depth_vals[i], eta = eta_vals[j])
      
      cv.output <- xgb.cv(data=Dtrain_sift,params=my.params, nrounds = 500, 
                          nfold = 5, nthread = 2, early_stopping_rounds = 7, 
                          verbose = 0, maximize = F, prediction = T,
                          objective = "binary:logistic")
      
      best_iter <- cv.output$best_iteration
      min_err <- min(cv.output$evaluation_log$test_error_mean)
      
      #update the "best_ " variables with value corresponding to min cv error
      if (min_err < best_err){
        best_params <- my.params ; best_err <- min_err
        best_nrounds <- best_iter
      }
      #update data.table of cv.errors 
      #cv.errors[[i,j]] = list(min_err,best_iter)
    }
  }

  #train best model
  run.time <- system.time(m <- xgb.train(data=Dtrain_sift, params=best_params, 
                             nrounds=best_nrounds, nthread = 2, 
                             objective = "binary:logistic"))
  run.time <- round(run.time[1],3)
  cat("Time for training model: " ,run.time, "s \n")

  summary.xgb <- data.table(Model = "XGBoost",
             Best_Param_1 = paste("max_depth =",best_params[[1]]),
             Best_Param_2 = paste("eta =", best_params[[2]]),
             Best_Param_3 = paste("nrounds =", best_nrounds),
             Best_Error = best_err,
             Training_Time = paste(run.time, "s"))
  #save(summary.xgb, file="output/summary_best_xgb.RData")
  return(summary.xgb)
}
#tune.xgb()


###############################################################################

##if it's decided that xgboost is best candidate for advanced model
##then source this R file and call this function in train.R
train.xgb <- function(dat_train,label_train,par_list,nrounds){
  #use parameters from tuning with CV on the sift features of training images 
  #best_params <- list(max_depth=5, eta=.5) ; nrounds=169 
  label_train <- as.numeric(label_train) #label vals in range [0,1] for logistic reg.
  Dtrain <- xgb.DMatrix(data=dat_train,label=label_train)
  xgb.m <- xgb.train(data=Dtrain, params=par_list, 
                     nthread = 2, nrounds = nrounds,
                     objective = "binary:logistic")
  return(xgb.m)
}