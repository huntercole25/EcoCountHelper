#' Scale data by two standard deviations
#' 
#' This function is very similar to the \code{\link[base]{scale}} function in that it centers 
#' and scales data, but scaling is accomplished by dividing the centered data by two standard 
#' deviations rather than one as detailed in Gelman (2008).
#' 
#' @param x A vector to be scaled.
#' 
#' @section References:
#' Gelman, A. (2008). Scaling regression inputs by dividing by two standard deviations. 
#' Statistics in Medicine, 27(15), 2865–2873. \url{https://doi.org/10.1002/sim.3107}
#' 
#' @export


scale2 <- function(x){
  (x - mean(x))/(2*stats::sd(x))
}