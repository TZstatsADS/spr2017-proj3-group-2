#KNN classification

require(e1071)
require(data.table)
require(class)

train_sift <- read.csv("data/train/sift_features.csv")
train_sift <- t(as.matrix(train_sift))
train_labels <- read.csv("data/train/labels.csv")
train_labels <- as.factor(as.matrix(train_labels)[,1])

#tune parameter k for KNN classification via 10-fold cross-validation
tune.knn <- function(){
  obj <- tune.knn(train_sift,train_labels,k=1:5)
  best_k <- obj$best.parameters[[1]]
  best_err <- obj$best.performance

  summary.knn <- data.table(Model = "KNN",
                            Best_Param_1 = paste("k =",best_k),
                            Best_Param_2 = NA, Best_Param_3 = NA,
                            Best_Error = best_err,
                            Training_Time = NA)
  save(summary.knn, file="output/summary_best_knn.Rdata")
  return(summary.knn)
}

train.knn <- function(dat_train,label_train){
  best_k <- 1 #best parameter after tuning with 10-fold cross-validation
  return(best_k) #nothing to train for knn 
}