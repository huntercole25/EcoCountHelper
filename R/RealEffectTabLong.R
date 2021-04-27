#' @rdname RealEffectTabLong
#' @export

RealEffectTabLong <- function(Models, Predictors, UnitChanges, ConfInt = 95, Pvals = T, GroupCol, 
                              GroupPat = "^[[:alnum:]]+",
                              ScaleSds = rep(NA, length(Predictors)), PredVects = ScaleSds,
                              Data = NULL, Precision = 2){
  if("glmmTMB" %in% class(Models)){
    Models <- deparse(substitute(Models))
  }
  
  FullEffects <- list()
  
  ChangeTab <- data.table::data.table(Predictors = Predictors, UnitCh = UnitChanges,
                                      ScaleSd = ScaleSds)
  
  for(i in Models){
    TmpMod <- get(i, envir = .GlobalEnv)
    Group <- regmatches(i, regexpr(GroupPat, i))
    
    for(j in 1:nrow(ChangeTab)){
      if(is.na(ChangeTab[j,ScaleSd])==F){ChangeTab[j,PredCol := PredVects[j]]}
      Predictor <- ChangeTab[j,Predictors]
      UnitChange <- ChangeTab[j,UnitCh]
      
      if(Pvals == T){
        Pval <- data.table::as.data.table(
          summary(TmpMod)$coeff$cond, keep.rownames=T)[rn == Predictor, round(`Pr(>|z|)`, Precision)]
      }
      
      PredBeta <- summary(TmpMod)$coeff$cond[Predictor,1]
      PredSe <- summary(TmpMod)$coeff$cond[Predictor,2]
      
      if(is.na(ChangeTab[j,ScaleSd]) == T){
        TmpDat <- data.table::data.table(
          Model = i,
          Predictor = ChangeTab[j,Predictors],
          UnitChange = UnitChange,
          DeltaPct = (-(1-exp(PredBeta)^UnitChange))*100)
        
        TmpDat[,LowerConf := round(DeltaPct -
                 ((-(1-exp((stats::qnorm(1-((100-ConfInt)/2/100))*PredSe)))^UnitChange)*100), Precision)]
        TmpDat[,UpperConf := round(DeltaPct +
                 ((-(1-exp((stats::qnorm(1-((100-ConfInt)/2/100))*PredSe)))^UnitChange)*100), Precision)]
        if(Pvals == T){
          TmpDat[,Pval := Pval]
        }
      }else{
        PredColName <- ChangeTab[j,PredCol]
        PredVect <- Data[[PredColName]][Data[[GroupCol]] == Group]
        TmpDat <- data.table::data.table(
          Model = i,
          Predictor = ChangeTab[j,Predictors],
          UnitChange = UnitChange,
          DeltaPct = (-(1-exp(PredBeta/(ChangeTab[j,ScaleSd]*stats::sd(PredVect)))^UnitChange))*100)
        
        TmpDat[,LowerConf := round(DeltaPct -
                 (-(1-exp((stats::qnorm(1-((100-ConfInt)/2/100))*PredSe)/
                            (ChangeTab[j,ScaleSd]*stats::sd(PredVect)))^UnitChange))*100, Precision)]
        TmpDat[,UpperConf := round(DeltaPct +
                 (-(1-exp((stats::qnorm(1-((100-ConfInt)/2/100))*PredSe)/
                            (ChangeTab[j,ScaleSd]*stats::sd(PredVect)))^UnitChange))*100, Precision)]
        if(Pvals == T){
        TmpDat[,Pval := Pval]
        }
      }
      TmpDat[,DeltaPct := round(DeltaPct, Precision)]
      
      FullEffects <- c(FullEffects, list(TmpDat))
    }
  }
  data.table::rbindlist(FullEffects)
}
