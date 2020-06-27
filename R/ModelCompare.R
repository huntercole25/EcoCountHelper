#' Model selection tool for multiple groups
#'
#' This function allows users to input a list/vector of groups (taxonomic or otherwise), each of which
#' has multiple candidate models generated with \code{\link[glmmTMB]{glmmTMB}}, and quickly attain AIC tables for each group. Group names supplied to the
#' \code{Groups} argument are used as text patterns supplied to \code{\link[base]{ls}} as \code{pattern}
#' argument values, and model objects in the global environment containing the supplied group names are
#' compared via \code{\link[stats]{AIC}}.
#'
#' @param Groups A character vector of groups (e.g. species, demographics), each with two or more candidate
#' models to be compared. Because the values supplied for this argument are essentially used as
#' regular expression text patterns to search the global environment, model object names must contain a
#' value supplied to this argument to be included in the comparisons.
#'
#' @param TopModOutName An unquoted string used as the object name for the resultant data table showing
#' the top model for each group supplied to the \code{Groups} argument.
#'
#' @return This function produces n+1 data tables, with n being the number of groups supplied to the
#' \code{Groups} argument. A data table detailing each model in a group and its AIC value is produed for each
#' group. Each of these data tables is named with the group name followed by "AIC" (e.g., the data table
#' associated with a group named "Epfu" would be named "EpfuAIC"). An additional data table is produced
#' detailing the top model for each group. The data table of top models is named with the value supplied
#' to the \code{TopModOutName} argument.
#'
#' @examples
#' data("EpfuNb1Long", "EpfuNb2Long", "MyevNb1Long",
#'       "MyevNb2Long", package = "EcoCountHelper")
#'       
#' Species <- c("Epfu", "Myev")
#' ModelCompare(Species, TestCompare)
#' 
#' EpfuAIC
#' MyevAIC
#' TestCompare
#'
#' @export

ModelCompare <- function(Groups, TopModOutName){
  TopMods <- list()

  ModCompSub <- function(Group){
    ModVect <- Filter(function(x) inherits(get(x), "glmmTMB"), ls(pattern = Group, envir = .GlobalEnv))
    AicList <- list()
    for(i in 1:length(ModVect)){
      TmpMod <- get(ModVect[i], envir = .GlobalEnv)
      TmpAic <- data.table::data.table(Model = ModVect[i], Aic = AIC(TmpMod), Subj = Group)
      AicList <- c(list(TmpAic), AicList)
    }
    FinalAicTab <- data.table::rbindlist(AicList)

    assign(paste0(Group,"AIC"), FinalAicTab, envir = .GlobalEnv)

    PreTopMods <- get("TopMods")
    GroupTopMod <- data.table::data.table(Subj = Group, TopModel = na.omit(FinalAicTab)[Aic == min(Aic), Model])
    TopMods <<- c(list(GroupTopMod), PreTopMods)

  }

  lapply(Groups, ModCompSub)

  FinalToppers <- data.table::rbindlist(TopMods)
  assign(deparse(substitute(TopModOutName)), FinalToppers, envir = .GlobalEnv)
}
