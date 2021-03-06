Draw the ideogram
=================

*Rossella Alfano, Brigitte Reimann, Congrong Wang and Michelle Plusquin*

In this tutorial, we will write a script to generate the ideogram of a
circular plot to display the features in a multi-omics matrix.

You can download the data you need for this tutorial
[here](https://github.com/rossellaalfano/Circular-plots/tree/main/data).
This folder contains three sub-folders:

-   the “multi\_omics-matrix” folder including the multi-omics matrix,

-   the “annotation” folder where the annotation file that is needed in
    the tutorial is stored,

-   the “circos\_files” folder in which you can find already the outputs
    of this tutorial.

Please, change the data path in Rstudio “data/” to the location where
you stored the “multi\_omics”, “annotation” and “circos\_files” folders.

Code to draw the ideogram
=========================

In the script below, change the data path “data/” to the location of the
folders “multi\_omics”, “annotation” and “circos\_files” and load the
annotation that you would like to be added to the ideogram.

``` r
#####################Draw the ideogram#####################
rm(list = ls())

##read the annotation
readRDS("data/annotation/ideogram_annotation.rds")->annot#please, change the data path in Rstudio “data/” to the location where you stored the “annotation” folder
```

Run the function below on the annotation file to generate the
“karyotype” of your circular plot.

In this tutorial each chromosome of the karyotype corresponds to an omic
layer. For each omic layer the function also defines “bands” that
represent group of omic features in the same omic layer sharing some
properties: eg same genomic regions of genes for the CpGs, same
chromosomic location of genes for gene expression, same phyla for
microbes and same metabolites classes for metabolites.

``` r
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
```

Run the function below on the annotation file to generate the labels of
each omic feature included in your circular plot.

``` r
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
```

Run the function below on the annotation file to generate the bands
labels of your circular plot.

``` r
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
```

Now that you have all the files needed for plotting the ideogram:

-   karyotype.txt

-   band\_labels.txt

-   labels.txt

You can [Run
Circos](https://github.com/rossellaalfano/Circular-plots/blob/main/4_RunCircos.md)
to draw your ideogram!
