# Multi-omics visualization via circular plots
*Rossella Alfano, Brigitte Reimann, Congrong Wang and Michelle Plusquin*



This hands-on tutorial is part of the [Microbiome Data Analysis Workshop](https://mdawo.meetinghand.com/). 

In this tutorial, we will introduce the visualization of multi-omics in circular plots using the [circos software](http://circos.ca/), similar to what has been done in [this paper](https://doi.org/10.1016/j.metabol.2020.154292). Circos is a visualization tool created by [Krzywinski et al](10.1101/gr.092759.109).

Please find included below the links to the circos software's download and installation instructions and all the tutorials.
We highly recommend that you download the simulated [multi-omics matrix](linkxxx), so you have some data to generate the circular plot. However, the tutorial can be virtually run on any kind of omic data. 

# Download and installation instructions

- [Download Circos](http://circos.ca/software/download/circos/)
- [Install Circos](http://circos.ca/software/installation/)
- [Download the multi-omics matrix](linkxxx)

# Tutorials

- [Draw the ideogram](linkxxx)
- [Draw the track](linkxxx)
- [Draw the links](linkxxx)
- [Run Circos](linkxxx)

# Glossary

Some of these terms may be used interchangeably throughout the workshop, but they are not exactly the same. Please find included below the definitions as we use them. 

- Omics:  the addition of [omics](http://omics.org/) to a molecular term implies a comprehensive, or global, assessment of a set of molecules . The first omics discipline to appear, genomics, was focused on the study of entire genomes as opposed to “genetics” which interrogated individual variants or single genes. Since then, many other omics technologies have been developed that are capable of interrogating entire pools of DNA methylation, transcripts, microorganisms, and metabolites. For more information see [here](https://doi.org/10.1186/s13059-017-1215-1).

- Omic layer: the word layer nearby omics is only used in multi-omics contexts. An omic layer identifies a specific biological layer, for example the methylome, the metabolome, the transcriptome, the microbiome, as single omic layers. 

- Omic feature: each biological feature composing an omic layer, for example all the probes (CpG sites) belonging to the methylome or all the transcripts included in the transcriptome.

- Ideogram: it is the circular axis of the plot. Ideograms were first used in the genetic field to depict the chromosomes, or region thereof, in images. However, the axes of a circular plot can correspond to an interval of any integer-valued variable. In this tutorial, we use ideograms to depict not different chromosomes, but different omic layers.

- Chromosome: in circos the entire sequence structure needed to be drawn in the ideogram is called chromosome and should be defined in the "karyotype file". In this tutorial, the chromosomes corresponds to each omic layer.

- Karyotype file: a file defining the size, identity, label and color of each chromosome. If available, band position can be defined in this file. In our tutorial, the karyotype file includes size, identity, labeland color of each omic layer.

- Bands: are highlight in each chromosome depicted in the ideogram. They are used in the genomic context to define cytogenetic bands. In the context of this tutorial, bands are used to group omic features sharing same genomic regions of genes associated to CpGs, same chromosomes, same phyla and same metabolites classes.

- Labels: define the text that is shown in the circular figure. In this tutorial, labels are used to name each omic layer, each group of omic feature and each omic feature.

- Links: are used to show the relationships between positions on axes. In this tutorial, they define the correlation coefficients between the different omic features belonging to the different omic layers.



