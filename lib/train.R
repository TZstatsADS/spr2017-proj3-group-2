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
  ###source files where functions are located
  source("lib/xgboost.R")
  #source("lib/tune")

##########============BASELINE MODEL============##########
  ### Train with gradient boosting model
    ##use 'best' parameters from training images
   #base_best_params <-  
   #base_best_n.trees <-
   #best_fit_base <- 

##########============ADVANCED MODEL============##########
  #source("***.R")
  #best_fit_adv <- train.***(dat_train,label_train)
  
  adv_best_params <- list(max_depth=5, eta=.5) 
  adv_best_nrounds=169 #e.g. tuned on SIFT features
  best_fit_adv <- train.xgb(dat_train,label_train,par_list=best_params,best_nrounds)
  
  
##########============OUTPUT DATA============##########
  
  # output = list(baseline_fit = gbm.object , base_best_iter= integer,
  #               advanced_fit =  xgb.Booster object, adv_best_iter= integer)
  output <- list(baseline_fit=best_fit_base, base_best_iter=adv_best_n.trees,
                 advanced_fit=best_fit_adv,adv_best_iter=adv_best_nrounds)
  save(output,file="output/trained_models.RData")
  return(output)
  
  
}
