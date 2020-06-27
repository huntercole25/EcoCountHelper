#' A not-so-smart plot arranger
#'
#' This function is a wrapper for \code{\link[cowplot]{plot_grid}} that removes unnecessary axis labels for
#' plots that are not along the left side of the plot. While it was initially intended to incorporate
#' a "smart-adjust" feature that would scale all plots without y-axis labels to be the same width as the plot
#' areas with y-axis labels, this function requires manual resizing of the furthest-left column of plots to
#' make them the same size as the others, hence the name DumbGrid rather than SmartGrid.
#'
#' @param ... Unquoted object names of ggplot objects to be included in the resultant grid of plots.
#'
#' @param Ncols A number indicating the number of columns that should be used in the plot grid.
#'
#' @param FirstColWidth A number indicating the relative width of the first column of plots compared to all
#' other columns. A value of 1 sets the left-most column at the same width as all others.
#'
#' @param SharedLegend A Boolean value indicating whether plots should share a legend (T), or have their own
#' legend (F).
#'
#' @return This function produces a grid of plots constructed from the plots supplied to the \code{...}
#' argument. Plots that are not in the left-most columns will not have y-axis labels.
#'
#' @examples
#' data("EpfuNb2Long", package = "EcoCountHelper")
#' EffectsPlotter(EpfuNb2Long, c(":)", "!", "argument", "FirstColWidth",
#'                            "the", "with", "adjusted", "be", "to",
#'                            "need", "plots", "These"))
#'                            
#' ExPlot <- EpfuNb2LongEffectsPlot
#' 
#' #First grid attempt
#' 
#' TestGrid <- DumbGrid(ExPlot, ExPlot, ExPlot, ExPlot,
#'                       Ncols = 2)
#' TestGrid #View the plot in a separate window
#'
#' #Adjusting the first column width to make plot sizes equal
#'
#' TestGrid2 <- DumbGrid(ExPlot, ExPlot, ExPlot, ExPlot,
#'                        Ncols = 2, FirstColWidth = 1.35)
#' TestGrid2 #View the plot in a separate window
#'
#' @export

DumbGrid <- function(..., Ncols, FirstColWidth = 1, SharedLegend = F){

  plots <- list(...)

  nplot <- length(plots)

  for(i in setdiff(seq(1, nplot, 1), seq(1, nplot, Ncols))){
    plots[[i]] <- plots[[i]] + ggplot2::theme(axis.title.y = element_blank(), axis.text.y = element_blank())
}
  plnums <- seq(1, nplot, 1)
  nox <- plnums[plnums < max(seq(1, nplot, Ncols))]

  for(i in nox){
    plots[[i]] <- plots[[i]] + ggplot2::theme(axis.title.x = element_blank())
  }

  if(SharedLegend == T){
    shleg <- cowplot::get_legend(plots[[1]])
    for(i in 1:length(plots)){
      plots[[i]] <- plots[[i]] + ggplot2::theme(legend.position = "none")
    }
  }

  Tplot <- cowplot::plot_grid(plotlist = plots, ncol = Ncols, rel_widths = c(FirstColWidth,rep(1, Ncols - 1)),
                     align = "v", axis = "tbr")

  if(SharedLegend == T){
    Tplot <- cowplot::plot_grid(Tplot, shleg, ncol = 2, rel_widths = c(9,1))
  }

  Tplot
}


