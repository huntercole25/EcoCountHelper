#' A ggplot2 theme that's dark as the night, and easy on the eyes
#'
#' This plot theme was inspired by a need to simultaneously plot data and maintain a reasonable level of dark-adapted (scotopic) visual ability while doing fieldwork at night.
#' \code{theme_nocturnal()} can be used in the same way as any of the native ggplot2 themes.
#'
#'@section Details:
#'To make adjustments to your plot's theme while using this function, using ggplot2's
#' \code{\link[ggplot2]{theme}} in a line proceeding \code{theme_nocturnal()}.
#'
#' @examples
#' #Creating a plot with theme_nocturnal
#' library(ggplot2)
#'
#' DarkPlot <- ggplot(cars, aes(speed, dist)) +
#'   geom_point(color = "grey80") + #Note the specification of a light color for the points
#'   theme_nocturnal()
#'
#' #Changing the axis text size of a theme_nocturnal plot
#'
#' DarkPlot2 <- DarkPlot +
#'   theme(axis.text = element_text(size = 4))
#'
#' @export

theme_nocturnal <- function(){
  ggplot2::theme(plot.background = ggplot2::element_rect(fill = "black"),
      panel.background = ggplot2::element_rect(fill = "black"),
      panel.grid.major = ggplot2::element_line(color = "grey20"),
      panel.grid.minor = ggplot2::element_line(color = "grey20"),
      axis.text = ggplot2::element_text(color = "grey70", size = 14),
      axis.ticks = ggplot2::element_line(color = "grey50"),
      legend.background = ggplot2::element_rect(fill = "black"),
      legend.text = ggplot2::element_text(color = "grey70", size = 11),
      legend.title = ggplot2::element_text(color = "grey70", size = 11, face = "bold"),
      legend.key = ggplot2::element_rect(fill = "black", color = "black"),
      plot.title = ggplot2::element_text(color = "grey70", hjust = 0.5, margin = ggplot2::margin(0, 0, 10, 0), size = 18,
                                face = "bold"),
      axis.title = ggplot2::element_text(color = "grey70", size = 16, face = "bold"),
      axis.line.y = ggplot2::element_line(color = "grey50"),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(10, 0, 0, 0)),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(0, 10, 0, 0)))
}
