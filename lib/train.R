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
    depth <- best_params$depth 

  ##fit the model with specified depth parameter
  fit_gbm <- gbm.fit(x=dat_train, y=label_train,
                     n.trees=2000,
                     distribution="bernoulli",
                     interaction.depth=depth, 
                     bag.fraction = 0.5,
                     verbose=FALSE)
  #check performance: best number of trees/iterations?  
  best_iter <- gbm.perf(fit_gbm, method="OOB", plot.it = FALSE)
  ##fit the model with best depth parameter and best n.trees parameter
  best_fit_gbm <- gbm.fit(x=dat_train, y=label_train,
                           n.trees=best_iter,
                           distribution="bernoulli",
                           interaction.depth=depth, 
                           bag.fraction = 0.5,
                           verbose=FALSE)
  
##########============ADVANCED MODEL============##########
  #source("***.R")
  #best_fit_adv <- train.***(dat_train,label_train)
  
##########============OUTPUT DATA============##########
  
  # output = list(baseline_fit = gbm.object , advanced_fit =  *** object)
  output <- list(baseline_fit=best_fit_gbm, advanced_fit=best_fit_adv)
  save(output,file="output/trained_models.RData")
  return(output)
  
  
}
