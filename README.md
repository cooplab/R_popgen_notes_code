## R Course Materials for Population Genetics


<br/>

This R package contains a few datasets, functions, and documentation for Population
and Quantitative Genetics. The R package is currently called EVE102.

## Installing R and RStudio

To use the EVE/PBGG R package, you will need to first download and install R 
and RStudio. If you already have up-to-date versions of R and RStudio, you 
may skip to the section 'Installing This R Package' below.

1. **Download R and Install R**.
2. Before class starts you’ll want to download and install a copy of R and R studio, information here:
3. https://posit.co/download/rstudio-desktop/

Open RStudio and try entering:

```{R, eval=FALSE}
print("Welcome to Popbio")
```

in the window labeled "Console". It should look something like this (but your
exact session will be different):

<img src="vignettes/images/rstudio_popbio.png" style="width: 600px;"/>


## Installing This R Package
To install this package, copy and paste the following into R:

```R
install.packages("devtools", dependencies=TRUE)
library(devtools)
install_github("cooplab/R_popgen_notes_code", build_vignettes=TRUE)
```

Then, try the following:

```R
library(eve102)
tutorials()
```

which should open up a list of tutorials in your browser.

## Updating this Package

Throughout the course, we will make updates to this package and documentation.
You can always check if your `eve102` course package is up to date with:

```R
eve102_status()
```

If your package is out of date, update it with:

```R
eve102_update()
```

## Accessing the R Tutorials

The R tutorials for this course are contained in this package. These will open
the R tutorials in your default browser. To browse all tutorials, use:

```R
library(eve102)
tutorials()
```

Then, click the "HTML" link for the tutorial you wish to read.

Specific tutorials can be accessed by providing a tutorial number. For example,
to access the first tutorial, use:

```R
tutorials(1)
```

## Working with the EVE102 Datasets

This package contains all of the data you will need for the exercises in this
course. Since learning to load data into R is a valuable skill you should
learn, the data is stored in tab-separated value (TSV) files within the
package. Depending on your system (Mac, Windows, or Linux), this data may live
in different places, so to find the file path to the data, use the function
`eve102_data()`. Calling this function without arguments returns all datasets:

```R
> library(eve102)
> eve102_data()
  id                 file                                     description
1  1     CEU_10000.txt.gz             10,000 HapMap SNPs, CEU individuals
2  2 CEU_YRI_10000.txt.gz     10,000 HapMap SNPs, CEU and YRI individuals
3  3     YRI_10000.txt.gz             10,000 HapMap SNPs, YRI individuals
>
```

Then, you can get the file path for one of these files by calling the
`eve102_data()` function, providing the filename you wish to get the path to:

```R
> eve102_data("CEU_10000.txt.gz")
[1] "/usr/local/lib/R/3.3/site-library/eve102/extdata/CEU_10000.txt.gz"
```

This can then be used to load data in with R's `read.table()` function (since
this is in tab-separated value format).

```R
> d <- read.table(eve102_data("CEU_10000.txt.gz"), header=TRUE)
> head(d)
  chr           snp allele_A allele_a AA Aa aa  freq total
1   1 SNP_A-1909444        T        C 40 19  1 0.825    60
2   1 SNP_A-2237149        0        G  0  0 60 0.000    60
3   1 SNP_A-4303947        A        G 45 15  0 0.875    60
4   1 SNP_A-1886933        T        C  0 15 45 0.125    60
5   1 SNP_A-2236359        A        0 60  0  0 1.000    60
6   1 SNP_A-2205441        0        C  0  0 60 0.000    60
```
