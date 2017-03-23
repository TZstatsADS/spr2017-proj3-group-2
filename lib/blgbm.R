## Function to tune parameters of baseline gbm model with given SIFT features of 
#   training images
## Function to train data to fit baseline model given the 'best' params from 
#   tuning via cross-validation 

#train_sift <- read.csv("data/train/sift_features.csv")
#train_sift <- t(as.matrix(train_sift))
#train_labels <- read.csv("data/train/labels.csv")
#train_labels <- as.factor(as.matrix(train_labels)[,1])

#Call this function to reproduce process of tuning params for baseline model via 5-fold CV
# -- Returns a summary data.table object that details best parameters used (ntrees and shrinkage)
#    based on training images and also saves the object (fitted best baseline model) in a .RData file 
set.seed(15)
tune.bl<- function(dat_train, label_train) {
  
  label_train<- as.factor(label_train)
  library("gbm")
  library("caret")
  library(data.table)
  
  gbmGrid<- expand.grid(n.trees=300, interaction.depth=1, shrinkage=seq(0.01, 0.25, 0.05), n.minobsinnode=10)
  
  trainGBM<- train(x=dat_train, y=label_train, distribution="bernoulli", method="gbm", tuneGrid=gbmGrid,   
                   trControl = trainControl(method = "cv", number = 5, 
                                            verboseIter = FALSE, 
                                            returnResamp = "all"))
  
  best_ntrees<- gbm.perf(trainGBM$finalModel, method="OOB")
  best_shrinkage<- trainGBM$bestTune[3]

  best_err<- 1- max(trainGBM$results$Accuracy)


  #train best model
 run.time<-system.time(baseline_train<- gbm.fit(x=dat_train, y=label_train, n.trees=best_ntrees, distribution="bernoulli", interaction.depth=1, 
                                               shrinkage= best_shrinkage, bag.fraction=0.5,verbose=FALSE))
 run.time <- round(run.time[1],3)
 cat("Time for training model: " ,run.time, "s \n")
 
  summary.bl <- data.table(Model = "BL GBM",
                           Best_Param_1 = paste("shrinkage =", best_shrinkage),
                           Best_Param_2 = paste("ntrees=", best_ntrees), Best_Param_3 = NA,
                           Best_Error = best_err,
                           Training_Time = paste(run.time, "s"))
  
  #save(summary.bl, file="output/summary_best_blgbm.RData")
  #return(list(sum=summary.bl, output=trainGBM, model=baseline_train)) 
  return(summary.bl)
  
} 

#tune.bl(train_sift,train_labels)


###
### source this R file and call this function in train.R
train.bl <- function(dat_train,label_train,par_list){
  #use parameters from tuning with CV on the sift features of training images 
  #best_params <- list(ntrees=64, shrinkage=0.16) 

   bl.gbm<-gbm.fit(x=dat_train, y=label_train, n.trees=par_list$ntrees, distribution="bernoulli", interaction.depth=1, 
                   shrinkage= par_list$shrinkage, bag.fraction=0.5,verbose=FALSE)

  return(bl.gbm)
}
