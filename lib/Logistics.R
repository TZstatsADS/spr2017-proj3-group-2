# train.logit() for Logistic Regression
dat_train <- read.csv("D:/training_data/training_data/sift_features/sift_features.csv")
dat_train <- t(as.matrix(dat_train))
label_train <- read.csv("D:/training_data/training_data/labels.csv")
label_train <- as.factor(as.matrix(label_train)[,1])
#############################
sgd_fit<- sgd(dat_train,label_train,model='glm',model.control=binomial(link="logit"))
pred <- predict(sgd_fit, dat_train,type = 'response')  
pred <- ifelse(pred <= 0.5, 0, 1) 
run.time <- system.time(sgd_fit)
run.time <- round(run.time[1],3)
run.time
cat("Time for training model: " ,run.time, "s \n")

cv.error <- mean(pred != label_train)
print(cv.error)

save(pred, file="D:/training_data/output/model-logistic.RData")
