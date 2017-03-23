# Project: Labradoodle or Fried Chicken? In Black and White. 
![image](figs/poodleKFC.jpg)

### [Full Project Description](doc/project3_desc.html)

Term: Spring 2017

+ Team #2
+ Team members
	+ Ka Heng (Helen) Lo
	+ Jia Hui Tan
	+ Bo Peng - *Presenter
	+ Yingxin Zhang
	+ Yao Tvan

+ Project summary: In this project, we created a classification engine for grayscale images of poodles versus grayscale images of fried chicken. 
	
**Contribution statement**: ([default](doc/a_note_on_contributions.md)) 
+ Ka Heng (Helen) Lo: 
	+ Wrote function to tune parameters for XGBoost model and function to train the *best* XGBoost model; tuned & trained based on SIFT features and three new feature sets 
	+ Wrote function to tune parameters for SVM with linear kernel and function to train *best* SVM with linear kernel; tuned & trained based on SIFT features 
	+ Wrote function to tune SVM with RBF (radial) kernel and function to train *best* SVM with RBF (radial) kernel; tuned & trained based on SIFT features
	+ Wrote function to tune AdaBag model and function to train the *best* AdaBag model; tuned and trained based on SIFT features
	+ Wrote function to tune AdaBoost.M1 model and function to train the *best* AdaBoost.M1 model; tuned & trained based on SIFT features
	+ Wrote function to tune AdaBoost_SAMME model and function to train the *best* AdaBoost_SAMME model; tuned & trained based on SIFT features
	+ Wrote function to tune KNN model and function to train the *best* KNN model; tuned & trained based on SIFT features
	+ Wrote main.Rmd script with summary table outputs for model selection process for Advanced Model
	+ Wrote train.R 
	+ Wrote test.R
	
+ Jia Hui Tan: 
	+ Wrote function to tune GBM (baseline model) and function to train *best* GBM; tuned & trained based on SIFT features and three new feature sets
	
+ Bo Peng: 
	+ 
	+ Prepared presentation
	
+ Yingxin Zhang: 
	+ 
	
+ Yao Tvan: 
	+ Wrote function to tune (i.e. find best subset of predictors) Logistic Regression model and function to train *best* Logistic Regression model; tuned & trained based on SIFT features 


Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is organized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
