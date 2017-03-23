### Author: Ka Heng (Helen) Lo
### Project 3
### ADS Spring 2017
#############################################################################
### Train baseline and advanced classification model with training images ###
#############################################################################

train <- function(dat_train_base=NULL,dat_train_adv=NULL, label_train, model = "both"){
  ### Input: 
  ###  -  R object that contains processed training set features 
  ###  -  R object of training sample labels.
  ###  -  type = string; either "baseline" or "advanced"
  ### Output: 
  ###      RData file that contains trained classifiers 
  ###      in the forms of R objects
  
  ### load libraries
  library("gbm")
  ###source files where functions are located
  source("../lib/xgboost.R")
  source("../lib/blgbm.R")
  
  if (model == "both") { #Return both Baseline & Advanced models

  ##########============BASELINE MODEL============##########
  ### Train with gradient boosting model
    ##use 'best' parameters from training images
    base_best_params <-  list(ntrees=64, shrinkage=0.16) #tuned on sift features 
    base_best_n.trees <- 64
    best_fit_base <- train.bl(dat_train_base, label_train, par_list=base_best_params)

  ##########============ADVANCED MODEL============##########
  #xgboost on SIFT-resize+adaptive features 
    adv_best_params <- list(max_depth=7, eta=.5) 
    adv_best_nrounds=45 
    best_fit_adv <- train.xgb(dat_train_adv,label_train,par_list=adv_best_params,adv_best_nrounds)
  
  ##########============OUTPUT DATA============##########
  
    # output = list(baseline_fit = gbm.object , base_best_iter= integer,
    #               advanced_fit =  xgb.Booster object, adv_best_iter= integer)
    output <- list(baseline_fit=best_fit_base, base_best_iter=base_best_n.trees,
                   advanced_fit=best_fit_adv,adv_best_iter=adv_best_nrounds)
    return(output)
  }
  
  else if (model == "base"){
    ##########============BASELINE MODEL============##########
    ### Train with gradient boosting model
    ##use dat_train_base
    ##use 'best' parameters from training images
    base_best_params <-  list(ntrees=64, shrinkage=0.16) #tuned on sift features 
    base_best_n.trees <- 64
    best_fit_base <- train.bl(dat_train_base, label_train, par_list=base_best_params)
    
    base.output <- list(baseline_fit=best_fit_base, base_best_iter=base_best_n.trees)
    return(base.output)
  }
  
  else if (model == "advanced"){
    ##########============ADVANCED MODEL============##########

    adv_best_params <- list(max_depth=7, eta=.5) 
    adv_best_nrounds=45 #e.g. tuned on SIFT features
    best_fit_adv <- train.xgb(dat_train_adv,label_train,par_list=adv_best_params,adv_best_nrounds)
    
    adv.output <- list(advanced_fit=best_fit_adv, adv_best_iter=adv_best_nrounds)
    return(adv.output)
  }
  
}
