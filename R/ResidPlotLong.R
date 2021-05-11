#' @rdname ResidPlotLong
#' 
#' @export
#' 
ResidPlotLong <- function (Data, CountCol, GroupCol, ModNames, GroupPat = "^[[:alnum:]]+", 
                           Looped = T, Nsims = 1000, TestVals = T) 
{
  ResidPlotterSub <- function(GroupMod) {
    TmpFile1 <- paste0(tempfile(), ".png")
    TmpFile2 <- paste0(tempfile(), ".png")
    
    TmpMod <- get(Filter(function(x) inherits(get(x), "glmmTMB"), 
                         ls(pattern = GroupMod, pos = .GlobalEnv)), pos = .GlobalEnv)
    Group <- regmatches(GroupMod, regexpr(GroupPat, GroupMod))
    TmpFull <- Data[Data[[GroupCol]] == Group, ]
    if (Looped == T) {
      TmpMod <- stats::update(TmpMod, data = TmpFull)
    }
    ModTab <- stats::simulate(TmpMod, nsim = Nsims)
    SimMod <- do.call(cbind, ModTab)
    SimModDharma <- DHARMa::createDHARMa(simulatedResponse = SimMod, 
                                         observedResponse = TmpFull[[CountCol]], fittedPredictedResponse = stats::predict(TmpMod), 
                                         integerResponse = TRUE)
    GroupResidTests <- DHARMa::testResiduals(SimModDharma, plot = F)
    grDevices::png(TmpFile1)
    graphics::par(mfrow = c(1,2))
    DHARMa::plotQQunif(SimModDharma, testUniformity = F, testOutliers = F, testDispersion = F)
    graphics::title(sub = GroupMod, font.sub = 2)
    DHARMa::testDispersion(SimModDharma)
    grDevices::dev.off()
    
    grDevices::png(TmpFile2)
    graphics::par(mfrow = c(1,1))
    DHARMa::testOutliers(SimModDharma)
    grDevices::dev.off()
    
    Plot1 <- png::readPNG(TmpFile1)
    Plot2 <- png::readPNG(TmpFile2)
    
    Plot1Gr <- grid::rasterGrob(Plot1)
    Plot2Gr <- grid::rasterGrob(Plot2)
    
    gridExtra::grid.arrange(Plot1Gr, Plot2Gr, nrow = 1)
    
    ResidPlot <- grDevices::recordPlot()
    assign(paste0(GroupMod, "SimResidPlot"), ResidPlot, 
           pos = .GlobalEnv)
    if (TestVals == T) {
      assign(paste0(GroupMod, "ResidTests"), GroupResidTests, 
             pos = .GlobalEnv)
    }
  }
  lapply(ModNames, ResidPlotterSub)
}