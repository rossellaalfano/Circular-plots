Download the multi-omics matrix
===============================

*Rossella Alfano, Brigitte Reimann, Congrong Wang and Michelle Plusquin*

You can download the multi-omic matrix
[here](https://github.com/rossellaalfano/Circular-plots/tree/main/data/multi_omics_matrix)

In case you are interested in the process through which you can generate
a multi-omic matrix starting from different omic dataset, you can follow
the tutorial below in which we use simple correlation to integrate the
datasets.

Tutorial to generate the multi-omics matrix from different omic dataset
=======================================================================

Download the data sources
-------------------------

The multi-omics matrix was generated using 4 simulated omic datasets as
source data:

1.  cord blood metabolomics (UHPLC-QTOF-MS system, Agilent Technologies)
2.  cord blood RNA microarray (Agilent Whole Human Genome 8 × 60 K
    microarrays)
3.  cord blood DNA methylation (Illumina HumanMethylation 450K BeadChip)
4.  faecal 16S microbiome

For the purpose of this tutorial maximum 20 omic features have been
included in each dataset. You can download the datasets
[here](https://github.com/rossellaalfano/Circular-plots/tree/main/data/omics).

Code to integrate the omic datasets and generate the multi-omics matrix
-----------------------------------------------------------------------

The code used to generate the multi-omics matrix correlating all the
omic datasets is provided below.

Please, over all the script change the data path “data/omics/” to the location where you
stored the 4 datasets. 

``` r
#####################Build the correlation matrix#####################
rm(list = ls())
##read the name of the datasets you are going to integrate
file_list <- list.files("data/omics/")#please, note that this function reads all the files that are in the folder, so make sure only the 4 omic datasets are in the folder. Please, change change the data path “data/omics/” to the location where you stored the 4 datasets. 
file_list <- grep(file_list[nchar(file_list) > 12 & nchar(file_list) < 20], pattern = '.rds', value = TRUE)
print(file_list)#here only the 4 omic layers we are going to integrate should appear. If not, check that  only the 4 omic datasets are in the folder
```

    ## [1] "metabolomics.rds"    "methylome.rds"       "microbiome.rds"     
    ## [4] "transcriptomics.rds"

The loop below will generate one correlation matrix for each of the
possible combinations of the omic datasets.

``` r
list<-t(combn(c(gsub(".rds","",file_list)),2))#generate all the possible combinations 
print(list)#check that all the possible combination are correct
```

    ##      [,1]           [,2]             
    ## [1,] "metabolomics" "methylome"      
    ## [2,] "metabolomics" "microbiome"     
    ## [3,] "metabolomics" "transcriptomics"
    ## [4,] "methylome"    "microbiome"     
    ## [5,] "methylome"    "transcriptomics"
    ## [6,] "microbiome"   "transcriptomics"

``` r
##run the loop to generate the correlation matrix for each pair
for (l in c(1:nrow(list))){
#load the data
omic_layer1<-list[l,1]
omic_layer2<-list[l,2]
readRDS(file=paste0("data/omics/",omic_layer1,".rds" ))->omic1#please, change the data path “data/omics/” to the location where you stored the 4 datasets. 
readRDS(file=paste0("data/omics/",omic_layer2,".rds" ))->omic2#please, change the data path “data/omics/” to the location where you stored the 4 datasets. 
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
saveRDS(results[!is.na(results$pval),],paste0("data/omics/correlation_", omic_layer1,"_" , omic_layer2, ".rds"))#please, change the data path “data/omics/” to the location where you stored the 4 datasets. 
    }
}
```

The “plyr” package will combine, correlation matrices in one, using the
ldpy function.

``` r
##load the packages plyr 
#if not installed on your computer, run the line below:
#install.packages("plyr")#
#load the library
library(plyr)
##read all the matrices in one dataset and save it
file_list <- list.files("data/omics/", pattern="correlation")#please, change the data path “data/omics/” to the location where you stored the 4 datasets. 
dataset <- ldply(paste0("data/omics/",file_list), readRDS)#please, change the data path “data/omics/” to the location where you stored the 4 datasets. 
saveRDS(dataset, "data/multi_omics_matrix/multiomics_matrix.rds")#please, change the data path “data/multi_omics_matrix/” to the location where you want to stored the multi omics matrix
```
