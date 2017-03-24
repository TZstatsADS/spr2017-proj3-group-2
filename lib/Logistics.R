# train.logit() for Logistic Regression
dat_train <- read.csv("D:/training_data/training_data/sift_features/sift_features.csv")
dat_train <- t(as.matrix(dat_train))
label_train <- read.csv("D:/training_data/training_data/labels.csv")
label_train <- as.factor(as.matrix(label_train)[,1])
#############################

mod=glm(label_train~dat_train,family = "binomial")
step(mod,direction = "forward")

set.seed(0)
library(caret)
#install.packages("sgd")
library(sgd)
data=dat_train
label=label_train
K=5000
fold <- createFolds(1:dim(data)[1], K, list=T, returnTrain=F)
fold <- as.data.frame(fold)

cv.error <- rep(NA, K)

for (i in 1:K){
  test.data <- data[fold[,i],]
  train.data <- data[-fold[,i],]
  test.label <- label[fold[,i],]
  train.label <- label[-fold[,i],]
  
  fit <- sgd(train.data, train.label,model='glm',model.control=binomial(link="logit"))
  pred <- predict(fit, test.data,type = 'response')  
  pred <- ifelse(pred <= 0.5, 0, 1) 
  cv.error[i] <- mean(pred != test.label)
}
mean(cv.error)

run.time <- system.time(fit)
run.time <- round(run.time[1],3)
run.time
cat("Time for training model: " ,run.time, "s \n")


save(pred, file="D:/training_data/output/model-logistic.RData")
