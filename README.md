# EcoCountHelper  

## Package Purpose

`EcoCountHelper` is a R package designed to make the meaningful analysis of wildlife count data through generalized linear mixed-models (GLMMs) more accessible to land and 
wildlife managers with limited programmatic experience. GLMMs can be a powerful and flexible tool for analyzing hierarchical data 
(e.g., repeated counts of bat call sequences at multiple sites), but the lack of standardization surrounding these analyses paired with the requisite level of programmatic 
competence can make them daunting to approach for many biologists and ecologists. The `EcoCountHelper` package provides a structured framework for approaching GLMM analyses 
that simplifies the coding process necessary to conduct such analyses.


## Installing and Citing EcoCountHelper

### Installing
While obvious, it is important to have an appropriate version of R installed on your machine. The earliest version of R that this package has been tested with is 3.6.3, and thus we recommend updating your R install if you are using an earlier version of R.

The simplest way to install `EcoCountHelper` is to use the `install_github` function from the `devtools` package. Before proceeding with this the installation of EcoCountHelper, you must first ensure that you have the software "Rtools" installed [(available through this link)](https://cran.r-project.org/bin/windows/Rtools/), then ensure `devtools` is installed. To install and load `devtools` then install `EcoCountHelper`, use the code below:

```{r Install, eval=FALSE}
require(devtools)
install_github(repo = "huntercole25/EcoCountHelper", build_vignettes = T)
```

### Citing

After installing EcoCountHelper, to see citation information for the package use the line of code below:

```{r Cite, eval=FALSE}
citation("EcoCountHelper")
```

## Learning More  
For an in-depth example of the workflow and functions associated with this package, run the code below in your R session after installing `EcoCountHelper`:  
```{r}
vignette("EcoCountHelperExample")
```