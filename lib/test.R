### Author: Ka Heng (Helen) Lo
### Project 3
### ADS Spring 2017
######################################################
### Fit the classification model with testing data ###
######################################################


test <- function(fit_train, dat_test){
  
  ### Fit the classfication model with testing data
  
  ### Input: 
  ###  - the fitted classification model using training data
  ###  -  processed features from testing images 
  ### Output: training model specification
  
  ### load libraries
  library(gbm)
  library(xgboost)
  
  ##########============BASELINE MODEL============##########
  #fit_train$baseline_fit is a gbm.object class object
  pred_base <- predict(fit_train$baseline_fit, newdata=dat_test, 
                       n.trees = fit_train$base_best_iter,
                       type="response")
  
  ##########============ADVANCED MODEL============##########
  #fit_train$advanced_fit is a xgb.Booster class object
  pred_adv <- predict(fit_train$advanced_fit, newdata=dat_test)
                      #Note: Since we pass a xgb.Booster model object already fitted
                      #      with the best nrounds parameter (i.e. best iteration/n.trees
                      #      for boosting), then we can leave out the
                      #      ntreelimit = fit_train$adv_best_iter parameter in predict.xgb.Booster().
                      #      The predictions are the same with & without the ntreelimit parameter.
                      
  
  

  ##########============OUTPUT DATA============##########
  # TRUE=1; FALSE=0
  # Labradoodle=1; Fried Chicken=0
  output <- list(baseline_pred=as.numeric(pred_base > 0.5), 
                 advanced_pred=as.numeric(pred_adv > 0.5))
  return(output)
}

