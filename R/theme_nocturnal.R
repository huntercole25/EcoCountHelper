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
  ggplot2::theme(plot.background = element_rect(fill = "black"),
      panel.background = element_rect(fill = "black"),
      panel.grid.major = element_line(color = "grey20"),
      panel.grid.minor = element_line(color = "grey20"),
      axis.text = element_text(color = "grey70", size = 14),
      axis.ticks = element_line(color = "grey50"),
      legend.background = element_rect(fill = "black"),
      legend.text = element_text(color = "grey70", size = 11),
      legend.title = element_text(color = "grey70", size = 11, face = "bold"),
      legend.key = element_rect(fill = "black", color = "black"),
      plot.title = element_text(color = "grey70", hjust = 0.5, margin = margin(0, 0, 10, 0), size = 18,
                                face = "bold"),
      axis.title = element_text(color = "grey70", size = 16, face = "bold"),
      axis.line.y = element_line(color = "grey50"),
      axis.title.x = element_text(margin = margin(10, 0, 0, 0)),
      axis.title.y = element_text(margin = margin(0, 10, 0, 0)))
}
