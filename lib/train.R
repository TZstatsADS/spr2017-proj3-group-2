#############################################################################
### Train baseline and advanced classification model with training images ###
#############################################################################

train <- function(dat_train, label_train){
  ### Input: 
  ###  -  R object that contains processed training set features 
  ###  -  R object of training sample labels.
  ### Output: 
  ###      RData file that contains trained classifiers 
  ###      in the forms of R objects
  
  ### load libraries
  library("gbm")

##########============BASELINE MODEL============##########
  ### Train with gradient boosting model
    ##use 'best' parameters from training images
   #best_params <-  
   #best_fit_base <- 

##########============ADVANCED MODEL============##########
  #source("***.R")
  #best_fit_adv <- train.***(dat_train,label_train)
  
  best_params <- list(max_depth=5, eta=.5, nrounds=169) #e.g. tuned on SIFT features
  best_fit_adv <- train.xgb(dat_train,label_train,par_list=best_parms)
  
  
##########============OUTPUT DATA============##########
  
  # output = list(baseline_fit = gbm.object , advanced_fit =  *** object)
  output <- list(baseline_fit=best_fit_base, advanced_fit=best_fit_adv)
  save(output,file="output/trained_models.RData")
  return(output)
  
  
}
