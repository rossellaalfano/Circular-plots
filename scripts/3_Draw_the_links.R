#####################Draw the links#####################
rm(list = ls())
##set your working directory here
setwd("data/")#change the path to the one where you stored the folders "multi_omics", "annotation" and "circos_files" 
##read the multiomics matrix
readRDS("multi_omics_matrix/multiomics_matrix.rds")->dataset

##read the annotation
readRDS("annotation/ideogram_annotation.rds")->annot

#write the fuction to draw the link
writeLinks <- function(dataset, annot, fileout="circos_files/links.txt") {
  cat("",file=fileout)
  for(i in 1:nrow(dataset)) {
    coord1 <-  subset(annot, annot$chr == dataset[i, 'omic_layer1'] & annot$Name == dataset[i, 'omic1'])$coord[1]
    coord2 <- subset(annot, annot$chr == dataset[i, 'omic_layer2'] & annot$Name == dataset[i, 'omic2'])$coord[1]
    txt1 <- paste(dataset[i, 'omic_layer1'], coord1-1, coord1)
    txt2 <- paste(dataset[i, 'omic_layer2'], coord2-1, coord2)
    optionString <- sprintf(" corr=%f", dataset[i, 'corr'])
    cat(sprintf("%s %s%s\n", txt1, txt2, optionString),file=fileout,append=T)
  }
}

##check they are characters
writeLinks(dataset,annot)
