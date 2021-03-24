#####################Build the correlation matrix#####################
rm(list = ls())
##set your working directory here
setwd("G:/My Drive/microbiome_workshop/data/omics/")#change the path to the one where you stored the 4 omic datasets
##read the name of the datasets you are going to integrate
file_list <- list.files()#please, note that this function reads all the files that are in the folder, so make sure only the 4 omic datasets are in the folder
file_list <- grep(file_list[nchar(file_list) > 12 & nchar(file_list) < 20], pattern = '.rds', value = TRUE)
print(file_list)#here only the 4 omic layers we are going to integrate should appear. If not, check that  only the 4 omic datasets are in the folder

list<-t(combn(c(gsub(".rds","",file_list)),2))#generate all the possible combinations 
print(list)#check that all the possible combination are correct

##run the loop to generate the correlation matrix for each pair
for (l in c(1:nrow(list))){
  #load the data
  omic_layer1<-list[l,1]
  omic_layer2<-list[l,2]
  readRDS(file=paste0(omic_layer1,".rds" ))->omic1
  readRDS(file=paste0(omic_layer2,".rds" ))->omic2
  #transpose one of the dataset
  t(omic1)->omic1
  #create a matrix to store the results
  cor.matrix<-matrix(NA, nrow(omic1), ncol(omic2), dimnames=list(rownames(omic1),colnames(omic2)))
  cor.matrix.p<-matrix(NA, nrow(omic1), ncol(omic2), dimnames=list(rownames(omic1),colnames(omic2)))
  #run the correlation using cor.test function
  for (i in 1:nrow(omic1)) {
    r<-omic1[i,]
    for (j in 1:ncol(omic2)) {
      m<-omic2[,j]
      model<-cor.test(as.numeric(m),as.vector(r),method = c("spearman"))
      if (!inherits(model, "try-error")) {
        cor.matrix.p[i,j] <- model$p.value
        cor.matrix[i,j] <- model$estimate
      }
    }
    #tidy the results
    data.frame(omic1=rownames(cor.matrix)[row(cor.matrix)], 
               omic2=colnames(cor.matrix)[col(cor.matrix)], 
               corr=c(cor.matrix),
               pval=c(cor.matrix.p),
               omic_layer1= paste0(omic_layer1),
               omic_layer2= paste0(omic_layer2))->results
    results<-subset(results, results$pval< c(0.05))#run if you want to select significant pairs only
    if(nrow(results)==0) next#run with the previous line to skip if no correlation is significant
    #save the results (remove the correlations that were not compute)
    saveRDS(results[!is.na(results$pval),],paste0( "correlation_", omic_layer1,"_" , omic_layer2, ".rds"))
  }
}

##load the packages plyr 
#if not installed on your computer, run the line below:
#install.packages("plyr")#
#load the library
library(plyr)
##read all the matrices in one dataset and save it
file_list <- list.files( pattern="correlation")
dataset <- ldply(file_list, readRDS)
saveRDS(dataset, "multiomics_matrix.rds")