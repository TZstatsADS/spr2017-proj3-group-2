library("EBImage")
library(stringr)

img_dir <- "./training_data/raw_images"
n_files <- length(list.files(img_dir))

for(i in 1:n_files){
  ii <- str_pad(i, 4, pad = "0")
  img <- readImage(paste0(img_dir, "/","image_", ii,".jpg"))
  img1 <- resize(img,512,512)
  img2 <- thresh(img1, w=60, h=60, offset=0.06)
  writeImage(img2,file = paste0("./training_data/newraw_images/", "image_",ii,".jpg"))
}

