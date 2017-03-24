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
	+ Wrote individual functions to tune parameters for SVM with linear kernel, SVM with RBF (radial) kernel, AdaBag model, AdaBoost.M1 model, AdaBoost_SAMME model, and KNN model; tuned based on original SIFT features
	+ Wrote individual functions to train *best* SVM with linear kernel, SVM with RBF (radial) kernel, AdaBag model, AdaBoost.M1 model, AdaBoost_SAMME model, and KNN model; trained based on original SIFT features 
	+ Wrote main.Rmd script with summary table outputs for model selection process for Advanced Model
	+ Wrote train.R
	+ Wrote test.R
	
+ Jia Hui Tan: 
	+ Wrote function to tune GBM (baseline model) and function to train *best* GBM; tuned & trained based on SIFT features and three new feature sets
	
+ Bo Peng: 
	+ Feature Extraction
	+ Prepared presentation
	
+ Yingxin Zhang: 
	+ Pre-process images
	+ Wrote function to train a CNN model; trained and tested model with training images split into a training set and test set
	
+ Yao Tvan: 
	+ 


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
