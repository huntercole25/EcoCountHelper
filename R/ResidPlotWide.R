#' @rdname ResidPlotLong
#' 
#' @export

ResidPlotWide <- function(Data, ModNames, GroupPat = "^[[:alnum:]]+",
                         Nsims = 1000, TestVals = T){

  ResidPlotterSub <- function(GroupMod){
    TmpMod <- get(Filter(function(x) inherits(get(x), "glmmTMB"), ls(pattern = GroupMod,
                                                                     pos = .GlobalEnv)), pos = .GlobalEnv)
    Group <- regmatches(GroupMod, regexpr(GroupPat, GroupMod))
    ModTab <- stats::simulate(TmpMod, nsim = Nsims)
    SimMod <- do.call(cbind, ModTab)
    SimModDharma <- DHARMa::createDHARMa(simulatedResponse = SimMod, observedResponse = Data[[Group]],
                                         fittedPredictedResponse = predict(TmpMod), integerResponse = TRUE)
    
    GroupResidTests <- DHARMa::testResiduals(SimModDharma, plot = T)
    
    ResidPlot <- grDevices::recordPlot()
    assign(paste0(GroupMod, "SimResidPlot"), ResidPlot, pos = .GlobalEnv)
    if(TestVals == T){assign(paste0(GroupMod, "ResidTests"), GroupResidTests, pos = .GlobalEnv)}
  }
  lapply(ModNames, ResidPlotterSub)
}