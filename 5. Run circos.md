Run circos program
==================

*Rossella Alfano, Brigitte Reimann, Congrong Wang and Michelle Plusquin*

In this tutorial we will write a script to run the circus program to
display a multi-omics matrix. You can download the data you need for
this tutorial in the “circos\_files” folder
[here](https://github.com/rossellaalfano/Circular-plots/tree/main/data/circos_files).

This folder contains 4 files generated via this tutorial:

-   karyotype.txt, band\_labels.txt and labels.txt can be generated
    following this tutorial
    [here](https://github.com/rossellaalfano/Circular-plots/blob/main/2.%20Draw%20the%20ideogram.md)

-   links.txt can be generated following this tutorial
    [here](https://github.com/rossellaalfano/Circular-plots/blob/main/3.%20Draw%20the%20links.md)

3 configuration files (provided):

-   ideogram.conf

-   ideogram.lable.conf

-   link.conf

2 .png output files that are the images that you will generate using the
input files and the code provide in this tutorial:

-   ideogram.png

-   links.png

Please, after downloading and installing circos, copy the
“circos\_files” folder in the “etc” folder of circos.

Code to plot the circos figures
===============================

Please, before running the code check that you copyed the
“circos\_files” folder inside the “etc” folder of circos.

Plot the ideogram
-----------------

Then, with the next line, we use the “shell” function (please note that
if you are a MAC user you should use instead “system”) to run the circos
program using as configuration the file “ideogram\_conf.conf” and as
output file the file “ideogram.png.”. Please check that the paths
“/circos-0.69-9/bin/” and “/circos-0.69-9/etc/” correspond to the path
where “bin” and “etc” folders of circos are located on your computer.

``` r
shell(cmd = "/circos-0.69-9/bin/circos -conf circos_files/ideogram.conf -outputfile ideogram.png -outputdir /circos-0.69-9/etc/circos_files")
```

<img src="https://github.com/rossellaalfano/Circular-plots/blob/main/data/circos_files/ideogram.png" width="500" height="500"  class="img-responsive" alt="" />

Plot the links
--------------

Finally, run the last line below, to run the circos program using as
configuration the file “links.conf” and as output file the file
“links.png”

``` r
shell(cmd = "/circos-0.69-9/bin/circos -conf circos_files/links.conf -outputfile links.png -outputdir /circos-0.69-9/etc/circos_files")
```

<img src="https://github.com/rossellaalfano/Circular-plots/blob/main/data/circos_files/links.png" width="500" height="500"  class="img-responsive" alt="" />
