#' Visualize model effects
#'
#' This function produces effects plots for the conditional model of model objects produced by
#' \code{\link[glmmTMB]{glmmTMB}}. Effects can be plotted for multiple models in a single function call.
#' These effects plots are based on those found in: \emph{Bolker, Ben, et al.
#' "Owls example: a zero-inflated, generalized linear mixed model for count data."
#' Departments of Mathematics & Statistics and Biology,
#' McMaster University, Hamilton (2012)}.
#'
#' @param TopMods This argument can accept multiple input types, and is used to specify which models effects plots
#' should be generated for. If an effects plot is desired for a single model, users can supply the unquoted model
#' object name. If effects plots for multiple models are desired, users can supply either the unquoted name
#' of a character vector containing model object names, or the name of a data table or data frame containing a
#' character vector of model object names. If using the latter option, be sure to provide a value to the
#' \code{TopModCol} argument.
#'
#' @param ParamLabs A character vector of labels for each model estimate. Labels must be supplied for estimates in the
#' same order as the vector returned by \code{row.names(summary(x)$coeff$cond)}, where \code{x} is a model
#' object name.
#'
#' @param TopModCol A character string specifying the name of the column containing model object names in a
#' data frame or data table. This argument should only be used if \code{TopMods} is supplied with the name of
#' a data frame or data table.
#'
#' @param ConfInts A numeric vector specifying up to three condifence intervals as percent values from largest
#' to smallest (e.g., for 80\%, 90\%, and 95\% confidence intervals, supply \code{ConfInts = c(95, 90, 80)}).
#'
#' @param Scaled A Boolean value indicating whether model estimates are scaled (T) or not (F). When \code{Scaled = T},
#' there will be a dotted \code{\link[ggplot2]{geom_abline}} where estimates = 0.
#'
#' @param ThemeBlack A Boolean value indicating whether \code{\link{theme_nocturnal}} should be applied to plots
#' (T) or not (F).
#'
#' @return This function generates effects plots using \code{\link[ggplot2]{geom_point}} for point estimates and
#' \code{\link[ggplot2]{geom_errorbar}} for confidence intervals. Resultant plots are named with the model name
#' followed by "EffectsPlot" (e.g., for a model named "EpfuNb2", the effects plot would be named "EpfuNb2EffectsPlot").
#'
#' @section Details:
#' Because all models specified in a call to this function share estimate labels, all models in a a given call
#' to this function must have the same model formula.
#'
#' @examples
#' data("EpfuNb2", "MyevNb2", package = "EcoCountHelper")
#'
#' #Effects plot for a single model
#'
#' Labels <- letters[1:12]
#' EffectsPlotter(EpfuNb2, Labels)
#' EpfuNb2EffectsPlot
#'
#' #Effects plot for multiple models specified
#' #in a character vector.
#'
#' Mods <- c("EpfuNb2", "MyevNb2")
#' EffectsPlotter(Mods, Labels)
#' EpfuNb2EffectsPlot
#' MyevNb2EffectsPlot
#'
#' #Effects plot for multiple models specified
#' #in a data frame
#'
#' ModTable <- data.frame(Species = c("Epfu", "Myev"),
#'                         Mods = c("EpfuNb2", "MyevNb2"))
#' EffectsPlotter(ModTable, Labels, "Mods")
#' EpfuNb2EffectsPlot
#' MyevNb2EffectsPlot
#'
#' @export

EffectsPlotter <- function(TopMods, ParamLabs = NULL, TopModCol = NULL, ConfInts = c(90, 80), Scaled = T,
                               ThemeBlack = T){
  if("glmmTMB" %in% class(TopMods)){
    TmpMod <- deparse(substitute(TopMods))
  }else{
    TmpMod <- get(deparse(substitute(TopMods)))
    if(!is.null(TopModCol)){
      TmpMod <- as.character(TmpMod[[TopModCol]])
    }
  }
  EffectsPlotterSub <- function(TopMod){
    SpMod <- get(TopMod, envir = .GlobalEnv)
    if(is.null(ParamLabs) == T){
      ParamLabs = rownames(summary(SpMod)$coeff$cond)
    }
    PlotData <- data.table::as.data.table(summary(SpMod)$coeff$cond)
    PlotData[,Param := rownames(summary(SpMod)$coeff$cond)]
    PlotData[,Order := as.factor(c(1:nrow(PlotData)))]

    if(ThemeBlack == T){
      pocol = "grey80"
      barcol = "grey60"
    }else{
      pocol = "black"
      barcol = "grey40"
    }

    EffectsPlot <- ggplot(data = PlotData)

    if(Scaled == T){
      EffectsPlot <- EffectsPlot +
        geom_vline(xintercept = 0, linetype = 2, size = 1, color = "red")
    }

    if(length(ConfInts) >= 1){
      EffectsPlot <- EffectsPlot +
        geom_errorbar(aes(xmin = Estimate - (`Std. Error`*qnorm(1-((100-ConfInts[1])/2/100))),
                          xmax = Estimate + (`Std. Error`*qnorm(1-((100-ConfInts[1])/2/100))),
                          x = Estimate, y = Order), color = barcol, size = 1, width = 0.7)
    }
    if(length(ConfInts) >= 2){
      EffectsPlot <- EffectsPlot +
        geom_errorbar(aes(xmin = Estimate - (`Std. Error`*qnorm(1-((100-ConfInts[2])/2/100))),
                          xmax = Estimate + (`Std. Error`*qnorm(1-((100-ConfInts[2])/2/100))),
                          x = Estimate, y = Order), color = barcol, size = 1, width = 0.5)
    }
    if(length(ConfInts) == 3){
      EffectsPlot <- EffectsPlot +
        geom_errorbar(aes(xmin = Estimate - (`Std. Error`*qnorm(1-((100-ConfInts[3])/2/100))),
                          xmax = Estimate + (`Std. Error`*qnorm(1-((100-ConfInts[3])/2/100))),
                          x = Estimate, y = Order), color = barcol, size = 1, width = 0.3)
    }

    EffectsPlot <- EffectsPlot +
      geom_point(aes(x = Estimate, y = Order), color = pocol, size = 3) +
      scale_y_discrete(labels = ParamLabs, drop = T) +
      labs(x = "Estimate", y = "Term", title = TopMod) +
      theme_light() +
      theme(plot.title = element_text(hjust = 0.5))

    if(ThemeBlack == T){EffectsPlot <- EffectsPlot + theme_nocturnal()}

    assign(paste0(TopMod, "EffectsPlot"), EffectsPlot, envir = .GlobalEnv)
  }

  lapply(TmpMod, FUN = EffectsPlotterSub)
}
