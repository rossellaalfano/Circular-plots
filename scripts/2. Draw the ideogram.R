#####################Draw the ideogram#####################
rm(list = ls())
##set your working directory here
setwd("data/")#change the path to the one where you stored the folders "multi_omics", "annotation" and "circos_files" 

##read the annotation
readRDS("annotation/ideogram_annotation.rds")->annot


##generate the function to create the Karyotype txt file
writeKaryotype <- function(annot, fileout="circos_files/karyotype.txt") {
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
writeLabels <- function(annot, fileout="circos_files/labels.txt") {
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
writeBandLabels <- function(annot, fileout="circos_files/band_labels.txt") {
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

