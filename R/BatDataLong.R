#' Bat Data from Grand Teton National Park (2016-2017) in Long-form
#' 
#' The dataset used for the case study in Cole et al., 2021 in long-form.
#' 
#' @docType data
#' 
#' @usage data(BatDataLong)
#' 
#' @format A data table with 5880 rows and 25 variables:
#' \describe{
#'   \item{Site}{The site from which the data were collected as a factor.}
#'   \item{SampleDate}{The date on which data collection began.}
#'   \item{Species}{The bat species with which count values are associated.}
#'   \item{Count}{The number of call sequences positively identified by SonoBat for the species indicated by the Species vector.}
#'   \item{EastingUsAea}{Longitude coordinates (using the ESRI:102003 projection) for the data collection site.}
#'   \item{NorthingUsAea}{Latitude coordinates (using the ESRI:102003 projection) for the data collection site.}
#'   \item{Year}{The year in which data was collected as a factor.}
#'   \item{Yday}{The ordinal date of data collection.}
#'   \item{YdayScale}{Yday standardized using the \code{\link{scale2}} function.}
#'   \item{MoonPct}{The proportion of the moon that was illuminated during data collection.}
#'   \item{MoonScale}{MoonPct standardized using the \code{\link{scale2}} function.}
#'   \item{ManualForestPct}{The proportion of land surrounding the data collection site that was forest.}
#'   \item{ForestScale}{ManualForestPct standardized using the \code{\link{scale2}} function.}
#'   \item{ManualDevelPct}{The proportion of land surrounding the data collection site that was developed.}
#'   \item{DevelScale}{ManualDevelPct standardized using the \code{\link{scale2}} function.}
#'   \item{WaterDist}{The distance to the nearest water source in meters.}
#'   \item{WaterScale}{WaterDist standardized using the \code{\link{scale2}} function.}
#'   \item{Elev}{The elevation of the data collection site in meters.}
#'   \item{ElevScale}{Elev standardized using the \code{\link{scale2}} function.}
#'   \item{BrightCount}{The sum of brightness scores for lights surrounding the site of data collection.}
#'   \item{BrightScale}{BrightCount standardized using the \code{\link{scale2}} function.}
#'   \item{PropCool}{The proportion of lights with a subjectively classified cool hue surrounding the site of data collection.}
#'   \item{CoolScale}{PropCool standardized using the \code{\link{scale2}} function.}
#'   \item{StrWeight}{The summed inverse of the square root of distances (in meters) to porous buildings surrounding the site of data collection.}
#'   \item{StrScale}{StrWeight standardized using the \code{\link{scale2}} function.}
#' }
"BatDataLong"