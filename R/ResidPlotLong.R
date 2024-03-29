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
                         ls(pattern = paste0("^", GroupMod, "$"), pos = .GlobalEnv)), pos = .GlobalEnv)

    Group <- regmatches(GroupMod, regexpr(GroupPat, GroupMod))
    TmpFull <- Data[Data[[GroupCol]] == Group, ]
    if (Looped == T) {
      TmpMod <- stats::update(TmpMod, data = TmpFull)
    }
    ModTab <- stats::simulate(TmpMod, nsim = Nsims)
    SimMod <- do.call(cbind, ModTab)
    SimModDharma <- DHARMa::createDHARMa(simulatedResponse = SimMod,
                                         observedResponse = TmpFull[[CountCol]], fittedPredictedResponse = predict(TmpMod),
                                         integerResponse = TRUE)

    GroupResidTests <- DHARMa::testResiduals(SimModDharma, plot = T)
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
