#load library
library(survival)
library(ggplot2)

#load data
dogs <- read.csv('/Users/tracylee/raw_dogs/clean_without_dummies_5_nodead.csv')
attach(dogs)

summary(dogs)


# total survival curve
dogs.surv <- survfit(Surv(time_range, adopted)~ge, conf.type="none")
ggsurv(dogs.surv, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)
title(main="Rescue Dog Survival Curve")

#limit to 1 year
plot(dogs.surv, xlab="Days Available", ylab="Percent Remaining", xlim=c(0,365))
title(main="Rescue Dog Survival Curve Within 1 Year")


dogs$survival <- Surv(dogs$time_range, dogs$adopted)

#altered curves - kinda different
group <- animalAltered + animalAlterUnknown
n <- length(unique(group))
fit <- survfit(survival ~ group, data = dogs)
plot(fit, lty = 1:n, col=1:n, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(group),
  col=1:n,
  horiz=FALSE,
  bty='n')

#declawed curves - kinda different
fit <- survfit(survival ~ animalDeclawed + animalDeclawedUnknown, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#housetrained curves - no difference
fit <- survfit(survival ~ animalHousetrained + animalHousetrainedUnknown, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#microchipped curves - huge difference
fit <- survfit(survival ~ animalMicrochipped + animalMicrochippedUnknown, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#ok with cats curves - no difference
fit <- survfit(survival ~ animalOKWithCats + animalOKWithCatsUnknown, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#ok with dogs curves - only the unknown quantity adds difference
fit <- survfit(survival ~ animalOKWithDogs + animalOKWithDogsUnknown, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#ok with kids curves - little difference
fit <- survfit(survival ~ animalOKWithKids + animalOKWithKidsUnknown, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#specialneeds curves - little difference
fit <- survfit(survival ~ animalSpecialneeds + animalSpecialneedsUnknown, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#in foster curves - some difference
fit <- survfit(survival ~ in_foster , data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#mixedbreed curves - no difference
fit <- survfit(survival ~ animalMixedBreed, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#needs curves - little difference
fit <- survfit(survival ~ animalNeedsFoster, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#activity curves - little difference
fit <- survfit(survival ~ Highly.Active + Slightly.Active + Not.Active, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#agegroup curves - difference in first 100 days
fit <- survfit(survival ~ Adult + Baby + Senior + Young, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#sizegroup curves - some difference 
fit <- survfit(survival ~ Large + Medium + Small + X.Large, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#newpeople curves - huge difference 
fit <- survfit(survival ~ Aggressive + Cautious + Friendly + Protective, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#indoor outdoor curves - huge difference 
fit <- survfit(survival ~ Indoor.Only + Indoor.and.Outdoor + Outdoor.Only, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")

#gender curves - no difference 
fit <- survfit(survival ~ sex_male, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")



names(dogs)



results <- coxph(survival ~ animalAdoptionFee + animalAltered + animalBiggestPictures + animalBiggestVideos + animalDeclawed + 
                   animalHousetrained + animalMicrochipped + animalMixedBreed + 
                   animalNeedsFoster + animalNumPictures + animalNumVideos + 
                   animalOKWithCats + animalOKWithDogs + animalOKWithKids + 
                   animalSizeCurrent + animalSizePotential + 
                   animalSpecialneeds + animalUptodate + age_at_start+ in_foster + Highly.Active + Not.Active + Slightly.Active + animalAlterUnknown + 
                   animalDeclawedUnknown + animalMicrochippedUnknown + Adult + Baby + Senior + Young + 
                   Large + Medium + Small + X.Large + Indoor.Only + Indoor.and.Outdoor + 
                   Outdoor.Only + Aggressive + Cautious + Friendly + Protective + animalHousetrainedUnknown + 
                   animalMixedBreedUnknown + animalOKWithCatsUnknown + animalOKWithDogsUnknown + 
                   animalOKWithKidsUnknown + animalSpecialneedsUnknown + animalUptodateUnknown + 
                   mostly_black + search_string_num_terms  
                 sex_male + description_length, 
                 data = dogs)
summary(results)




















#ggsurv plots
ggsurv <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                   cens.col = 'red', lty.est = 1, lty.ci = 2,
                   cens.shape = 3, back.white = F, xlab = 'Time',
                   ylab = 'Survival', main = ''){
  
  library(ggplot2)
  strata <- ifelse(is.null(s$strata) ==T, 1, length(s$strata))
  stopifnot(length(surv.col) == 1 | length(surv.col) == strata)
  stopifnot(length(lty.est) == 1 | length(lty.est) == strata)
  
  ggsurv.s <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                       cens.col = 'red', lty.est = 1, lty.ci = 2,
                       cens.shape = 3, back.white = F, xlab = 'Time',
                       ylab = 'Survival', main = ''){
    
    dat <- data.frame(time = c(0, s$time),
                      surv = c(1, s$surv),
                      up = c(1, s$upper),
                      low = c(1, s$lower),
                      cens = c(0, s$n.censor))
    dat.cens <- subset(dat, cens != 0)
    
    col <- ifelse(surv.col == 'gg.def', 'black', surv.col)
    
    pl <- ggplot(dat, aes(x = time, y = surv)) +
      xlab(xlab) + ylab(ylab) + ggtitle(main) +
      geom_step(col = col, lty = lty.est)
    
    pl <- if(CI == T | CI == 'def') {
      pl + geom_step(aes(y = up), color = col, lty = lty.ci) +
        geom_step(aes(y = low), color = col, lty = lty.ci)
    } else (pl)
    
    pl <- if(plot.cens == T & length(dat.cens) > 0){
      pl + geom_point(data = dat.cens, aes(y = surv), shape = cens.shape,
                      col = cens.col)
    } else if (plot.cens == T & length(dat.cens) == 0){
      stop ('There are no censored observations')
    } else(pl)
    
    pl <- if(back.white == T) {pl + theme_bw()
    } else (pl)
    pl
  }
  
  ggsurv.m <- function(s, CI = 'def', plot.cens = T, surv.col = 'gg.def',
                       cens.col = 'red', lty.est = 1, lty.ci = 2,
                       cens.shape = 3, back.white = F, xlab = 'Time',
                       ylab = 'Survival', main = '') {
    n <- s$strata
    
    groups <- factor(unlist(strsplit(names
                                     (s$strata), '='))[seq(2, 2*strata, by = 2)])
    gr.name <-  unlist(strsplit(names(s$strata), '='))[1]
    gr.df <- vector('list', strata)
    ind <- vector('list', strata)
    n.ind <- c(0,n); n.ind <- cumsum(n.ind)
    for(i in 1:strata) ind[[i]] <- (n.ind[i]+1):n.ind[i+1]
    
    for(i in 1:strata){
      gr.df[[i]] <- data.frame(
        time = c(0, s$time[ ind[[i]] ]),
        surv = c(1, s$surv[ ind[[i]] ]),
        up = c(1, s$upper[ ind[[i]] ]),
        low = c(1, s$lower[ ind[[i]] ]),
        cens = c(0, s$n.censor[ ind[[i]] ]),
        group = rep(groups[i], n[i] + 1))
    }
    
    dat <- do.call(rbind, gr.df)
    dat.cens <- subset(dat, cens != 0)
    
    pl <- ggplot(dat, aes(x = time, y = surv, group = group)) +
      xlab(xlab) + ylab(ylab) + ggtitle(main) +
      geom_step(aes(col = group, lty = group))
    
    col <- if(length(surv.col == 1)){
      scale_colour_manual(name = gr.name, values = rep(surv.col, strata))
    } else{
      scale_colour_manual(name = gr.name, values = surv.col)
    }
    
    pl <- if(surv.col[1] != 'gg.def'){
      pl + col
    } else {pl + scale_colour_discrete(name = gr.name)}
    
    line <- if(length(lty.est) == 1){
      scale_linetype_manual(name = gr.name, values = rep(lty.est, strata))
    } else {scale_linetype_manual(name = gr.name, values = lty.est)}
    
    pl <- pl + line
    
    pl <- if(CI == T) {
      if(length(surv.col) > 1 && length(lty.est) > 1){
        stop('Either surv.col or lty.est should be of length 1 in order
             to plot 95% CI with multiple strata')
      }else if((length(surv.col) > 1 | surv.col == 'gg.def')[1]){
        pl + geom_step(aes(y = up, color = group), lty = lty.ci) +
          geom_step(aes(y = low, color = group), lty = lty.ci)
      } else{pl +  geom_step(aes(y = up, lty = group), col = surv.col) +
          geom_step(aes(y = low,lty = group), col = surv.col)}
    } else {pl}
    
    
    pl <- if(plot.cens == T & length(dat.cens) > 0){
      pl + geom_point(data = dat.cens, aes(y = surv), shape = cens.shape,
                      col = cens.col)
    } else if (plot.cens == T & length(dat.cens) == 0){
      stop ('There are no censored observations')
    } else(pl)
    
    pl <- if(back.white == T) {pl + theme_bw()
    } else (pl)
    pl
  }
  pl <- if(strata == 1) {ggsurv.s(s, CI , plot.cens, surv.col ,
                                  cens.col, lty.est, lty.ci,
                                  cens.shape, back.white, xlab,
                                  ylab, main)
  } else {ggsurv.m(s, CI, plot.cens, surv.col ,
                   cens.col, lty.est, lty.ci,
                   cens.shape, back.white, xlab,
                   ylab, main)}
  pl
}