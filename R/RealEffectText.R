#' Your personal glmmTMB model interpreter
#'
#' This function generates a sentence describing the effect of a model predictor on the response variable.
#' If model estimates are scaled and use a log link, this function can give "unscaled" effects of a predictor
#' on the response variable.
#'
#' @param Model The unquoted name of the model object of interest.
#'
#' @param Predictor A character string representing the predictor of interest. Appropriate values can be found by 
#' entering \code{row.names(summary(x)$coeff$cond)} in the console, where x is the model of interest.
#'
#' @param UnitChange A number indicating the unscaled change in a predictor for which an effect should be returned.
#'
#' @param ConfInt A number indicating the desired confidence interval as a percent value.
#'
#' @param ScaleSds A number indicating how many standard deviations a predictor has been scaled by.
#'
#' @param PredVect The unquoted name of a vector containing the raw data for the predictor of interest.
#'
#' @param UnitSymb A character string representing the units of the precictor of interest.
#'
#' @return This function returns a sentence describing the effect of a specified change in a predictor on the
#' response variable.
#'
#' @examples
#' #The effect of a 10% change increase in
#' #moon face illumination on Epfu activity
#'
#' data("EpfuNb2Long", "BatDataLong", package = "EcoCountHelper")
#'
#' RealEffectText(EpfuNb2Long, "scale2(MoonPct)",
#'                 0.1, ScaleSds = 2,
#'                 PredVect = BatDataLong$MoonPct)
#'


RealEffectText <- function(Model, Predictor, UnitChange = 1, ConfInt = 95,
                           ScaleSds = NULL, PredVect = NULL, UnitSymb = "unit"){
  PredBeta <- summary(Model)$coeff$cond[Predictor,1]
  PredSe <- summary(Model)$coeff$cond[Predictor,2]

  if(is.null(ScaleSds)==T){
    PctIncrease <- (-(1-exp(PredBeta)^UnitChange))*100
    FactIncrease <- exp(PredBeta)^UnitChange
    PctConfidence <- (-(1-exp((stats::qnorm(1-((100-ConfInt)/2/100))*PredSe)))^UnitChange)*100
  }else{
    PctIncrease <- (-(1-exp(PredBeta/(ScaleSds*stats::sd(PredVect)))^UnitChange))*100
    FactIncrease <- exp(PredBeta/(ScaleSds*stats::sd(PredVect)))^UnitChange
    PctConfidence <- (-(1-exp((stats::qnorm(1-((100-ConfInt)/2/100))*PredSe)/(ScaleSds*stats::sd(PredVect)))^UnitChange))*100
  }

  if(PctIncrease >= 0){
    delta <- "increases"
  }else{
    delta <- "decreases"
  }

  if(abs(FactIncrease) >= 2){
    ValString <- paste0("by a factor of ", round(abs(FactIncrease),2), " [", abs(round(PctIncrease,2)), "% (+/-", round(PctConfidence, 2),
                        "%)] ")
  }else{
    ValString <- paste0(round(abs(PctIncrease), 2), "% (+/- ", round(abs(PctConfidence),2), "%) ")
    }

  print(paste0("The response variable ", delta, " ", ValString, "for every ", UnitChange, " ", UnitSymb, " increase in the predictor."))
}

