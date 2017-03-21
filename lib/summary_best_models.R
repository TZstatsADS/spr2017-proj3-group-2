library(data.table)
load("output/summary_best_xgb.RData")
load("output/summary_best_svm_lin.Rdata")
load("../output/summary_best_svm_rad.Rdata")
load("output/summary_best_knn.Rdata")

load("output/summary_best_AdaBag.Rdata")
load("output/summary_best_AdaBag2.Rdata")
load("output/summary_best_AdaBoost.M1.Rdata")
load("output/summary_best_AdaBoost_SAMME.Rdata")

#6 columns: "Model", "Best_Param_1", "Best_Param_2", "Best_Param_3", 
#            "Best_Error", "Training_Time"
#  - NA values for Best_Param_2 and/or Best_Param_3 if model has less than 3 params
summary <- rbind(summary.xgb, summary.svm.lin,
                 summary.svm.rad, summary.AdaBag,
                 summary.AdaBag2, summary.AdaBoost.M1,
                 summary.AdaBoost_SAMME,
                 summary.knn) 
#sort table by Best_Error in ascending order
summary <- summary[order(summary$Best_Error)]

save(summary,file="output/summary_best_models.Rdata")
