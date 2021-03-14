#' @rdname ResidPlotLong
#' 
#' @export

ResidPlotWide <- function(Data, ModNames, GroupPat = "^[[:alnum:]]+",
                         Nsims = 1000, TestVals = T){

  ResidPlotterSub <- function(GroupMod){
    TmpFile1 <- paste0(tempfile(), ".png")
    TmpFile2 <- paste0(tempfile(), ".png")
    
    TmpMod <- get(Filter(function(x) inherits(get(x), "glmmTMB"), ls(pattern = GroupMod,
                                                                     pos = .GlobalEnv)), pos = .GlobalEnv)
    Group <- regmatches(GroupMod, regexpr(GroupPat, GroupMod))

    ModTab <- stats::simulate(TmpMod, nsim = Nsims)
    SimMod <- do.call(cbind, ModTab)
    SimModDharma <- DHARMa::createDHARMa(simulatedResponse = SimMod, observedResponse = Data[[Group]],
                                 fittedPredictedResponse = predict(TmpMod), integerResponse = TRUE)
    GroupResidTests <- DHARMa::testResiduals(SimModDharma, plot = F)
    
    png(TmpFile1)
    par(mfrow = c(1,2))
    DHARMa::plotQQunif(SimModDharma, testUniformity = F, testOutliers = F, testDispersion = F)
    title(sub = GroupMod, font.sub = 2)
    DHARMa::testDispersion(SimModDharma)
    dev.off()
    
    png(TmpFile2)
    par(mfrow = c(1,1))
    DHARMa::testOutliers(SimModDharma)
    dev.off()
    
    Plot1 <- png::readPNG(TmpFile1)
    Plot2 <- png::readPNG(TmpFile2)
    
    Plot1Gr <- grid::rasterGrob(Plot1)
    Plot2Gr <- grid::rasterGrob(Plot2)
    
    gridExtra::grid.arrange(Plot1Gr, Plot2Gr, nrow = 1)

    ResidPlot <- grDevices::recordPlot()
    assign(paste0(GroupMod, "SimResidPlot"), ResidPlot, pos = .GlobalEnv)
    if(TestVals == T){assign(paste0(GroupMod, "ResidTests"), GroupResidTests, pos = .GlobalEnv)}
  }
  lapply(ModNames, ResidPlotterSub)
}
