#' Visually examine the mean-variance relationship of data
#'
#' These functions plot data by group, and overlay lines representing three family functions that are
#' commonly used for count data: NB1, NB2, and Poisson. For more information on this, please reference
#' \href{https://groups.nceas.ucsb.edu/non-linear-modeling/projects/owls/WRITEUP/owls.pdf/@@@download}{this document.}
#' 
#' @name DistFitLong
#' 
#' @aliases DistFitWide
#' 
#' @param Splitters A character vector of column names to aggregate data by.
#'
#' @param Data The unquoted name of the data frame or data table containing the raw data models are based on.
#'
#' @param CountCol A character string specifying the name of the vector containing count data.
#' 
#' @param GroupCol A character string specifying the name of the vector containing group information (e.g., order, species) for each observation.
#'
#' @param GroupList A character vector of column names representing groups that define model membership (e.g., species, demographics).
#'
#' @param ThemeBlack A logical value indicating whether the plots generated should include \code{\link{theme_nocturnal}}
#' (T) or not (F).
#' 
#' @param Prefix A character string specifying a prefix to be assigned to the 
#' ggplot object generated as well as the plot title
#'
#' @return These functions produces a mean/variance plot with NB1, NB2, and Poisson family function lines for
#' each group in the vector supplied to the \code{GroupList} argument. Each resultant plot is named with
#' the group name followed by "DistPlot" (e.g., the plot associated with a group named "Epfu" would be named
#' "EpfuDistPlot".)
#' 
#' @examples
#' #DistFitWide Example
#' data("BatDataWide", package = "EcoCountHelper")
#' 
#' DistFitWide(c("Site", "Year"),
#'                 BatDataWide, c("Myev", "Epfu"))
#'                 
#' EpfuDistPlot
#' MyevDistPlot
#' 
#' #DistFitLong Example
#' data("BatDataLong", package = "EcoCountHelper")
#' 
#' DistFitLong(c("Site", "Year"),
#'   BatDataLong, "Count", "Species", c("Myev", "Epfu"))
#'   
#' EpfuDistPlot
#' MyevDistPlot
#'
#' @export
NULL