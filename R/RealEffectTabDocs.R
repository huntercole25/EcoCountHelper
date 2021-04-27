#' Tabulate meaningful effect sizes
#' 
#' These functions are akin to the \code{\link{RealEffectText}} function, but rather than generating a 
#' meaningful portrayal of a single predictor's effect on a model's response variable, the RealEffectTab 
#' functions tabulate effects of specified changes for multiple predictors (scaled or unscaled) and multiple 
#' models as a percent change in the response variable. The "Wide" and "Long" suffixes indicate the type of data
#' the function is meant to be used with.
#' 
#' @name RealEffectTabLong
#' 
#' @aliases RealEffectTabWide
#' 
#' @param Models Either a character vector of glmmTMB model object names, or the unquoted name of a single 
#' glmmTMB model object.
#' 
#' @param Predictors A character vector representing the predictors of interest. Appropriate values can be found
#' by entering \code{row.names(summary(x)$coeff$cond)} in the console, where x is the model of interest.
#' 
#' @param UnitChanges A numeric vector indicating the unscaled change in a predictor for which
#' effects should be returned in the order of the Predictors vector.
#' 
#' @param ConfInt A number indicating the desired confidence interval as a percent value.
#' 
#' @param Pvals A logical value indicating whether or not to append predictor p-values to the output table.
#' 
#' @param GroupCol A character string indicating the column name containing group membership information.
#' 
#' @param GroupPat A regular expression capable of extracting group membership information from model names.
#' 
#' @param ScaleSds A numeric vector indicating the how many standard deviations a predictor has been scaled by
#' in the order of the Predictors vector. If a predictor has not been scaled, its respective ScaleSds value
#' should be NA.
#' 
#' @param PredVects A character vector specifying the column names of the unscaled predictors.
#' 
#' @param Data The unquoted name of the table containing the unscaled predictor vectors, and when using
#' \code{RealEffectTabLong}, the group membership column.
#' 
#' @param Precision The number of digits right of the decimal to retain in values shown in the resultant table. 
#' Note that this argument only influences the values displayed in the resultant table, and no rounding occurs 
#' until all calculations are carried out.
#' 
#' @return These functions return a data table with six vectors: the name of the model that 
#' the change in the response variable is associated with, the name of the predictor that the change in the
#' response variable is associated with, the unscaled change in the predictor, the change in the response
#' variable expressed as a percentage, and the lower and upper confidence intervals expressed as percentages.
#' If \code{Pvals = T}, a seventh column with predictor p-values is also included.
#' 
#' @examples 
#' data("Epfu_Nb2", "Myev_Nb2", "Epfu_Nb2_Long",
#'      "Myev_Nb2_Long", "BatDataWide", "BatDataLong",
#'       package = "EcoCountHelper")
#' 
#' #RealEffectTabWide Single Model Example
#' RealEffectTabWide(Epfu_Nb2, Predictors = c("YdayScale", "MoonScale"),
#'                   UnitChanges = c(10, 0.3), ScaleSds = c(2,2),
#'                   PredVects = c("Yday", "MoonPct"), Data = BatDataWide)
#' 
#' #RealEffectTabWide Multiple Model Example
#' RealEffectTabWide(c("Epfu_Nb2", "Myev_Nb2"),
#'                   Predictors = c("YdayScale", "MoonScale"),
#'                   UnitChanges = c(10, 0.3), ScaleSds = c(2,2),
#'                   PredVects = c("Yday", "MoonPct"), Data = BatDataWide)
#'                   
#' #RealEffectTabLong Single Model Example
#' RealEffectTabLong(Epfu_Nb2_Long,
#'                   Predictors = c("YdayScale", "MoonScale"),
#'                   UnitChanges = c(10, 0.3), GroupCol = "Species",
#'                   GroupPat = "^[[:alpha:]]{4}", ScaleSds = c(2,2),
#'                   PredVects = c("Yday", "MoonPct"), Data = BatDataLong)
#' 
#' 
#' @export
NULL