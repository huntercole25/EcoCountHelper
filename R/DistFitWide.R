#' Visually examine the mean-variance relationship of data
#'
#' This function plots data by group, and overlays lines representing three family functions that are
#' commonly used for count data: NB1, NB2, and Poisson. For more information on this, please reference 
#' \href{https://groups.nceas.ucsb.edu/non-linear-modeling/projects/owls/WRITEUP/owls.pdf/@@@download}{this document.}
#'
#' @param Splitters A character vector of column names to aggregate data by.
#'
#' @param Data The unquoted name of the data frame or data table containing the raw data models are based on.
#'
#' @param GroupList A character vector of column names representing groups that define model membership (e.g., species, demographics).
#'
#' @param ThemeBlack A Boolean value indicating whether the plots generated should include \code{\link{theme_nocturnal}}
#' (T) or not (F).
#'
#' @return This function produces a mean/variance plot with NB1, NB2, and Poisson family function lines for
#' each group in the vector supplied to the \code{GroupList} argument. Each resultant plot is named with
#' the group name followed by "DistPlot" (e.g., the plot associated with a group named "Epfu" would be named
#' "EpfuDistPlot".)
#' 
#' @seealso \code{\link{DistFitLong}}
#'
#' @examples
#' data("BatDataWide", package = "EcoCountHelper")
#' 
#' DistFitWide(c("Site", "Year"),
#'                 BatDataWide, c("Myev", "Epfu"))
#'                 
#' EpfuDistPlot
#' MyevDistPlot
#'
#' @export

DistFitWide <- function(Splitters, Data, GroupList, ThemeBlack = T){

  Plotter <- function(GroupName){
    FullData <- get(deparse(substitute(Data)))
    Count <- FullData[[GroupName]]

    Params <- list()
    for(i in Splitters){
      Params[[i]] <- FullData[[i]]
    }

    VarData <- aggregate(Count, Params, FUN = var)[[length(Splitters)+1]]
    MeanData <- aggregate(Count, Params, FUN = mean)[[length(Splitters)+1]]

    MeanVarData <- as.data.frame(cbind(VarData, MeanData))

    if(ThemeBlack == T){pocol = "grey80"}else{pocol = "black"}

    TmpPlot <- ggplot2::ggplot(data = MeanVarData, ggplot2::aes(x = .data[["MeanData"]], y = .data[["VarData"]])) +
      ggplot2::geom_point(color = pocol) +
      ggplot2::geom_smooth(method = "lm", formula = y~x-1, ggplot2::aes(color = "NB1"), lty = 1) + #NB1
      ggplot2::geom_smooth(method = "lm", formula = y ~ I(x^2) + offset(x) - 1, ggplot2::aes(color = "NB2"), lty = 1) + #NB2
      ggplot2::geom_abline(aes(intercept = 0, slope = 1, color = "Poisson"), lty = 2) + #Poisson
      ggplot2::scale_color_manual(name = "Families", values = c("green", "purple", "red")) +
      ggplot2::labs(title = GroupName, x = "Mean", y = "Variance") +
      ggplot2::theme_light() +
      ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5, face = "bold"))

    if(ThemeBlack == T){
      TmpPlot <- TmpPlot + theme_nocturnal()
    }

    assign(paste0(GroupName, "DistPlot"), TmpPlot, pos = .GlobalEnv)
  }
  lapply(GroupList, FUN = Plotter)
}
