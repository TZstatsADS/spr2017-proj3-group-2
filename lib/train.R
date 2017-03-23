### Author: Ka Heng (Helen) Lo
### Project 3
### ADS Spring 2017
#############################################################################
### Train baseline and advanced classification model with training images ###
#############################################################################

train <- function(dat_train_base=NULL,dat_train_adv=NULL, label_train, model = NULL){
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
  source("lib/xgboost.R")
  #source("lib/tune")
  
  if (is.null(model)) { #Return both Baseline & Advanced models

  ##########============BASELINE MODEL============##########
    ### Train with gradient boosting model
      ##use dat_train_base
      ##use 'best' parameters from training images
    #base_best_params <-  
    #base_best_n.trees <-
    #best_fit_base <- 
  
  ##########============ADVANCED MODEL============##########
    #source("***.R")
    #best_fit_adv <- train.***(dat_train,label_train)

    adv_best_params <- list(max_depth=5, eta=.5) 
    adv_best_nrounds=169 #e.g. tuned on SIFT features
    best_fit_adv <- train.xgb(dat_train_adv,label_train,par_list=best_params,best_nrounds)
  
  ##########============OUTPUT DATA============##########
  
    # output = list(baseline_fit = gbm.object , base_best_iter= integer,
    #               advanced_fit =  xgb.Booster object, adv_best_iter= integer)
    output <- list(baseline_fit=best_fit_base, base_best_iter=adv_best_n.trees,
                   advanced_fit=best_fit_adv,adv_best_iter=adv_best_nrounds)
    return(output)
  }
  
  else if (model == "base"){
    ##########============BASELINE MODEL============##########
    ### Train with gradient boosting model
    ##use dat_train_base
    ##use 'best' parameters from training images
    #base_best_params <-  
    #base_best_n.trees <-
    #best_fit_base <- 
    base.output <- list(baseline_fit=best_fit_base, base_best_iter=adv_best_n.trees)
    return(base.output)
  }
  
  else if (model == "advanced"){
    ##########============ADVANCED MODEL============##########

    adv_best_params <- list(max_depth=5, eta=.5) 
    adv_best_nrounds=169 #e.g. tuned on SIFT features
    best_fit_adv <- train.xgb(dat_train_adv,label_train,par_list=best_params,best_nrounds)
    
    adv.output <- list(advanced_fit=best_fit_adv, adv_best_iter=adv_best_nrounds)
    return(adv.output)
  }
  
}
