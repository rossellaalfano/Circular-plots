#####################1. Build the correlation matrix#####################
rm(list = ls())
##read the name of the datasets you are going to integrate
file_list <- list.files("data/omics/")#please, note that this function reads all the files that are in the folder, so make sure only the 4 omic datasets are in the folder. Please, change the path to the one where you stored the 4 omic datasets
file_list <- grep(file_list[nchar(file_list) > 12 & nchar(file_list) < 20], pattern = '.rds', value = TRUE)
print(file_list)#here only the 4 omic layers we are going to integrate should appear. If not, check that  only the 4 omic datasets are in the folder

list<-t(combn(c(gsub(".rds","",file_list)),2))#generate all the possible combinations 
print(list)#check that all the possible combination are correct

##run the loop to generate the correlation matrix for each pair
for (l in c(1:nrow(list))){
#load the data
omic_layer1<-list[l,1]
omic_layer2<-list[l,2]
readRDS(file=paste0("data/omics/",omic_layer1,".rds" ))->omic1
readRDS(file=paste0("data/omics/",omic_layer2,".rds" ))->omic2
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
saveRDS(results[!is.na(results$pval),],paste0("data/omics/correlation_", omic_layer1,"_" , omic_layer2, ".rds"))
    }
}

##load the packages plyr 
#if not installed on your computer, run the line below:
#install.packages("plyr")#
#load the library
library(plyr)
##read all the matrices in one dataset and save it
file_list <- list.files("data/omics/", pattern="correlation")
dataset <- ldply(paste0("data/omics/",file_list), readRDS)
saveRDS(dataset, "data/multi_omics_matrix/multiomics_matrix.rds")

#####################2. Draw the ideogram#####################
rm(list = ls())

##read the annotation
readRDS("data/annotation/ideogram_annotation.rds")->annot#please, change the data path in Rstudio “data/” to the location where you stored the “annotation” folder

##generate the function to create the Karyotype txt file
writeKaryotype <- function(annot, fileout="data/circos_files/karyotype.txt") {#please, change the data path in Rstudio “data/” to the location where you stored the “circos_files” folder
  #if you only have chromosomes info run only this part of the loop
  cat("",file=fileout)
  chr <- unique(annot$chr)
  colors <- c("lgreen","dblue","vvlporange","dyellow")#define your colors
  for(ii in 1:length(chr)) {
    N <- nrow(annot[annot$chr == chr[ii],])
    txt <- paste('chr -', chr[ii] , chr[ii], 0, N, colors[ii])
    cat(txt, file=fileout, append=T)
    cat("\n", file=fileout, append=T)
  }
  #if you also have bands info run also this part of the loop
  for(ii in 1:length(chr)) {
    band <- annot[annot$chr == chr[ii],]
    min_coord<-tapply(band$coord,band$band,min)
    max_coord<-tapply(band$coord,band$band,max)
    min_coord<-min_coord[match(unique(band$band), names(min_coord))]
    max_coord<-max_coord[match(unique(band$band), names(max_coord))]
    band <- band[!duplicated(band$band),]
    band$min_coord<-min_coord
    band$max_coord<-max_coord
    colors <- c("white","grey")#define your colors
    for(jj in 1:length(band$band)) {
      bands <- gsub(" ", "_", band$band[jj])
      col <- ifelse((jj%%2),colors[[1]],colors[[2]])
      txt <- paste('band', chr[ii], bands,bands, band$min_coord[jj]-1, band$max_coord[jj], col)
      cat(txt, file=fileout,append=T)
      cat("\n", file=fileout, append=T)
    }	
  }
}

##run the function to create the Karyotype txt file
writeKaryotype(annot)

##generate the function to create the ideogram labels
writeLabels <- function(annot, fileout="data/circos_files/labels.txt") {#please, change the data path in Rstudio “data/” to the location where you stored the “circos_files” folder
  cat("",file=fileout)
  for(ii in 1:nrow(annot)) {
    label <- annot$label[ii]
    label <- gsub(" ", "_", label)
    cat(sprintf('%s\n', paste(annot$chr[ii], annot$coord[ii]-1, annot$coord[ii], label)),file=fileout,append=T)
  }
}

##run the function to create the ideogram labels
writeLabels(annot)

##generate the function to create the band_labels txt file
writeBandLabels <- function(annot, fileout="data/circos_files/band_labels.txt") {#please, change the data path in Rstudio “data/” to the location where you stored the “circos_files” folder
  cat("",file=fileout)
  chr <- unique(annot$chr)
  for(ii in 1:length(chr)) {
    band <- annot[annot$chr == chr[ii],]
    min_coord<-tapply(band$coord, band$band, FUN=min)
    max_coord<-tapply(band$coord, band$band, FUN=max)
    min_coord<-min_coord[match(unique(band$band), names(min_coord))]
    max_coord<-max_coord[match(unique(band$band), names(max_coord))]
    band <- band[!duplicated(band$band),]
    band$min_coord<-min_coord
    band$max_coord<-max_coord
    for(jj in 1:length(band$band)) {
      bands <- gsub(" ", "_", band$band[jj])
      txt <- paste( chr[ii], band$min_coord[jj]-1, band$max_coord[jj], bands)
      cat(txt, file=fileout,append=T)
      cat("\n", file=fileout, append=T)
    }	
  }
}

#run the function to generate the bands labels
writeBandLabels(annot)

#####################3. Draw the links#####################
rm(list = ls())

##read the multiomics matrix
readRDS("data/multi_omics_matrix/multiomics_matrix.rds")->dataset#change the path to the one where you stored the folders "multi_omics", "annotation" and "circos_files" 

##read the annotation
readRDS("data/annotation/ideogram_annotation.rds")->annot#change the path to the one where you stored the folders "multi_omics", "annotation" and "circos_files" 

#write the fuction to draw the link
writeLinks <- function(dataset, annot, fileout="data/circos_files/links.txt") {#change the path to the one where you stored the folders "multi_omics", "annotation" and "circos_files" 
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

shell(cmd = "/circos-0.69-9/bin/circos -conf circos_files/ideogram.conf -outputfile ideogram.png -outputdir /circos-0.69-9/etc/circos_files")
shell(cmd = "/circos-0.69-9/bin/circos -conf circos_files/links.conf -outputfile links.png -outputdir /circos-0.69-9/etc/circos_files")
