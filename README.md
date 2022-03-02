# GeneRenaming
Basic Gene Renaming R script to help rename from ENSEMBL gene names to other nomenclatures.

# Usage

Type in your directories into the R script, have the correct libraries installed, and run the script.

Typically following featureCounts, a directory may look like this: 

    01.txt
    02.txt
    03.txt
    
Where each of these txt files contain a featureCounts output for that specific sample/barcoded sample. GeneRenaming groups the text file information into a coherent counts table. Make sure these are the only txt files in the directory. You have the freedom to easily rename the columns at the end of the script. 


# Version

### Dependencies
 
dplyr_1.0.4    
biomaRt_2.42.1

### My R Session

R version 3.6.1 (2019-07-05)  
Platform: x86_64-conda_cos6-linux-gnu (64-bit)  
Running under: Ubuntu 20.04.1 LTS  
