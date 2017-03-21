require(adabag) #multiclass AdaBoost.M1, SAMME and Bagging algorithms 
require(data.table)

train_sift <- read.csv("data/train/sift_features.csv")
train_sift <- t(as.matrix(train_sift))
train_labels <- read.csv("data/train/labels.csv")
train_labels <- as.factor(as.matrix(train_labels)[,1])

##############################################################################

#Call this function to reproduce process of tuning params for bagging model via CV
# -- Returns a summary data.table object that details best parameters used 
#    based on training images and also saves the object in a .RData file 

tune.AdaBag <- function(){
  #tune mfinal parameter; find best number of iterations via 5-fold CV
  best_err <- Inf ; best_iter <- NULL
  cv.output.list <- list()
  
  mfinal.vals <- c(10,100) #default is 100
  set.seed(300)
  for (i in 1:2){
    mfinal.val <- mfinal.vals[i]
    cv.output <- bagging.cv(train_labels~.,v=5,
                            data=data.frame(train_labels,train_sift),
                            mfinal=mfinal.val, 
                            control=rpart.control(maxdepth=5))
    cv.output.list[[i]] <- cv.output
    cv.error <- cv.output$error
    
    if (cv.error < best_err){
      best_err <- cv.error
      best_iter <- mfinal.val
    }
    cat("bagging.cv() [", i, "] done \n", sep="")
  }
  
  #fit bagging algorithm using classification trees as single classifiers
  run.time <- system.time(AdaBag <- bagging(train_labels~.,
                                            data=data.frame(train_labels,train_sift),
                                            mfinal=best_iter,
                                            control=rpart.control(maxdepth=5)))
  run.time <- round(run.time[1],3)
  cat("Time for training model: ",run.time[1],"s \n")
  
  summary.AdaBag <- data.table(Model = "AdaBag",
                            Best_Param_1 = paste("mfinal =",best_iter),
                            Best_Param_2 = NA,
                            Best_Param_3 = NA,
                            Best_Error = best_err,
                            Training_Time = paste(run.time[1], "s"))
  save(summary.AdaBag,file="output/summary_best_AdaBag.Rdata")
  return(summary.AdaBag)
}
#tune.AdaBag()


###############################################################################

##if it's decided that bagging is best candidate for advanced model
##then source this R file and call this function in train.R
train.AdaBag <- function(dat_train,label_train){
  label_train <- as.factor(label_train)
  best_iter <- 10
  bag.m <- bagging(label_train~.,
                   data=data.frame(label_train,dat_train),
                   mfinal=best_iter,
                   control=rpart.control(maxdepth=5))
  return(bag.m)
}


##############################################################################

#Call this function to reproduce process of tuning params for AdaBoost.M1 model via CV
# -- Returns a summary data.table object that details best parameters used 
#    based on training images and also saves the object in a .RData file 

tune.AdaBoost.M1 <- function(){
  #tune mfinal parameter; find best number of iterations via 10-fold CV
  best_err <- Inf ; best_iter <- NULL
  cv.output.list <- list()
  mfinal.vals <- c(10,15,20)
  set.seed(37)
  for (i in 1:3){
    mfinal.val <- mfinal.vals[i]
    #AdaBoost.M1 algorithm 
    cv.output <- boosting.cv(train_labels~.,
                             data=data.frame(train_labels,train_sift),
                             mfinal=mfinal.val,
                             coeflearn="Freund",
                             control=rpart.control(maxdepth=3))
    cv.output.list[[i]] <- cv.output
    cat("boosting.cv() [",i,"] done \n", sep="")
    cv.error <- cv.output$error
    
    if (cv.error < best_err){
      best_err <- cv.error
      best_iter <- mfinal.val
    }
  }
  
  #fit AdaBoost.M1 algorithm using classification trees as single classifiers
  run.time <- system.time(AdaBoost.M1 <- boosting(train_labels~.,
                                                  data=data.frame(train_labels,train_sift),
                                                  mfinal=best_iter,
                                                  coeflearn="Freund",
                                                  control=rpart.control(maxdepth=3)))
  run.time <- round(run.time[1],3)
  cat("Time for training model: ",run.time,"s \n")
  
  summary.AdaBoost.M1 <- data.table(Model = "AdaBoost.M1",
                            Best_Param_1 = paste("mfinal =",best_iter),
                            Best_Param_2 = NA,
                            Best_Param_3 = NA,
                            Best_Error = best_err,
                            Training_Time = paste(run.time, "s"))
  save(summary.AdaBoost.M1,file="output/summary_best_AdaBoost.M1.Rdata")
  return(summary.AdaBoost.M1)
}
#tune.AdaBoost.M1()


###############################################################################

##if it's decided that AdaBoost.M1 is best candidate for advanced model
##then source this R file and call this function in train.R
train.AdaBoost.M1 <- function(dat_train,label_train){
  label_train <- as.factor(label_train)
  best_iter <- 15
  AdaBoost.M1 <- boosting(label_train~.,
                          data=data.frame(label_train,dat_train),
                          mfinal=best_iter,
                          coeflearn="Freund",
                          control=rpart.control(maxdepth=3))
  return(AdaBoost.M1)
}



###############################################################################


#Call this function to reproduce process of tuning params for AdaBoost_SAMME model via CV
# -- Returns a summary data.table object that details best parameters used 
#    based on training images and also saves the object in a .RData file 

tune.AdaBoost_SAMME <- function(){
  #tune mfinal parameter; find best number of iterations via 10-fold CV
  best_err <- Inf ; best_iter <- NULL
  cv.output.list <- list()
  mfinal.vals <- c(5,10,15)
  set.seed(45)
  for (i in 1:5){
    mfinal.val <- mfinal.vals[i]
    #AdaBoost SAMME algorithm 
    cv.output <- boosting.cv(train_labels~.,
                             data=data.frame(train_labels,train_sift),
                             mfinal=mfinal.val,
                             coeflearn="Zhu",
                             control=rpart.control(maxdepth=3))
    cv.output.list[[i]] <- cv.output
    cat("boosting.cv() [",i,"] done \n", sep="")
    cv.error <- cv.output$error
    
    if (cv.error < best_err){
      best_err <- cv.error
      best_iter <- mfinal.val
    }
  }
  
  #fit AdaBoost_SAMME algorithm using classification trees as single classifiers
  run.time <- system.time(AdaBoost_SAMME <- boosting(train_labels~.,
                                                     data=data.frame(train_labels,train_sift),
                                                     mfinal=best_iter,
                                                     coeflearn="Zhu",
                                                     control=rpart.control(maxdepth=3)))
  run.time<- round(run.time[1],3)
  cat("Time for training model: ",run.time,"s \n")
  
  summary.AdaBoost_SAMME <- data.table(Model = "AdaBoost_SAMME",
                            Best_Param_1 = paste("mfinal =",best_iter),
                            Best_Param_2 = NA,
                            Best_Param_3 = NA,
                            Best_Error = best_err,
                            Training_Time = paste(run.time, "s"))
  save(summary.AdaBoost_SAMME,file="output/summary_best_AdaBoost_SAMME.Rdata")
  return(summary.AdaBoost_SAMME)
}
#tune.AdaBoost_SAMME()

###############################################################################

##if it's decided that AdaBoost-SAMME is best candidate for advanced model
##then source this R file and call this function in train.R
train.AdaBoost_SAMME <- function(dat_train,label_train){
  label_train <- as.factor(label_train)
  best_iter <- 15
  AdaBoost_SAMME <- bagging(label_train~.,
                            data=data.frame(label_train,dat_train),
                            mfinal=best_iter,
                            coeflearn="Zhu",
                            control=rpart.control(maxdepth=3))
  return(AdaBoost_SAMME)
}

