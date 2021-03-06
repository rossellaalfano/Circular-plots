Draw the links
==============

*Rossella Alfano, Brigitte Reimann, Congrong Wang and Michelle Plusquin*

In this tutorial, we will write a script to generate the links of a
circular plot to display the correlations contained in a multi-omics
matrix.

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

Code to draw the links
======================

In the script below, change the data path “data/” to the location where
the folders “multi\_omics”, “annotation” and “circos\_files” and load
the multi-omics matrix and the annotation files.

``` r
#####################Draw the links#####################
rm(list = ls())

##read the multiomics matrix
readRDS("data/multi_omics_matrix/multiomics_matrix.rds")->dataset#change the path to the one where you stored the folders "multi_omics", "annotation" and "circos_files" 

##read the annotation
readRDS("data/annotation/ideogram_annotation.rds")->annot#change the path to the one where you stored the folders "multi_omics", "annotation" and "circos_files" 
```

Run the function below on the annotation file and multi-omics matrix to
generate the links of your circular plot.

``` r
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
```

Now the links.txt is ready for use.

You can [Run
Circos](https://github.com/rossellaalfano/Circular-plots/blob/main/4_RunCircos.md)
to plot the ideogram with links!
