######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Ka Heng (Helen) Lo
### Project 3
### ADS Spring 2017

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
  
  pred_base <- predict(fit_train$baseline_fit, newdata=dat_test, 
                       type="response")
  
  ##########============ADVANCED MODEL============##########
  
  pred_adv <- predict(fit_train$advanced_fit, newdata=dat_test)

  ##########============OUTPUT DATA============##########
  output <- list(baseline_pred=as.numeric(pred_base > 0.5), 
                 advanced_pred=as.numeric(pred_adv > 0.5))
  return(output)
}

