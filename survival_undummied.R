#load library
library(survival)
library(ggplot2)

#ggsurv plot for prettier survival curves
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

#load data
dogs <- read.csv('/Users/tracylee/Documents/galvanize/capstone/data/clean_data_no_dummies.csv')
attach(dogs)

summary(dogs)

# total survival curve
dogs.surv <- survfit(Surv(time_range, adopted)~ 1, conf.type="none")
ggsurv(dogs.surv, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)
title(main="Rescue Dog Survival Curve")

#limit to 1 year
plot(dogs.surv, xlab="Days Available", ylab="Percent Remaining", xlim=c(0,365))
title(main="Rescue Dog Survival Curve Within 1 Year")


dogs$survival <- Surv(dogs$time_range, dogs$adopted)

#altered curves - kinda different
fit <- survfit(survival ~ animalAltered, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#declawed curves - kinda different; declawed too low should expunge
fit <- survfit(survival ~ animalDeclawed, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#housetrained curves - no difference
fit <- survfit(survival ~ animalHousetrained, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#microchipped curves - huge difference = most likely indicates a dog that has an owner who will come looking for him/her
fit <- survfit(survival ~ animalMicrochipped, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#ok with cats curves - no difference
fit <- survfit(survival ~ animalOKWithCats, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#ok with dogs curves - significant difference
fit <- survfit(survival ~ animalOKWithDogs, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#ok with kids curves - little difference
fit <- survfit(survival ~ animalOKWithKids, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#specialneeds curves - little difference
fit <- survfit(survival ~ animalSpecialneeds, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#in foster curves - some difference
fit <- survfit(survival ~ in_foster , data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#mixedbreed curves - initially no difference
fit <- survfit(survival ~ animalMixedBreed, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#needs foster curves - little difference
fit <- survfit(survival ~ animalNeedsFoster, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#activity curves -  difference - sedentary is bad
fit <- survfit(survival ~ animalActivityLevel, data = dogs)
plot(fit, lty=1:5, col = 2:6, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(animalActivityLevel),
  lty=1:5,
  col=2:6,
  horiz=FALSE,
  bty='n')

#agegroup curves - difference in first 100 days
fit <- survfit(survival ~ animalGeneralAge, data = dogs)
plot(fit, lty=1:5, col = 2:6, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(animalGeneralAge),
  lty=1:5,
  col=2:6,
  horiz=FALSE,
  bty='n')

#sizegroup curves - some difference; people really like medium dogs
fit <- survfit(survival ~ animalGeneralSizePotential, data = dogs)
plot(fit, lty=1:5, col = 2:6, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(animalGeneralSizePotential),
  lty=1:5,
  col=2:6,
  horiz=FALSE,
  bty='n')

#newpeople curves - huge difference 
fit <- survfit(survival ~ animalNewPeople, data = dogs)
plot(fit, lty=1, col = 2:6, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(animalNewPeople),
  lty=1,
  col=2:6,
  horiz=FALSE,
  bty='n')

#indoor outdoor curves - huge difference 
fit <- survfit(survival ~ animalIndoorOutdoor, data = dogs)
plot(fit, lty=1:5, col = 2:6, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(animalIndoorOutdoor),
  lty=1:5,
  col=2:6,
  horiz=FALSE,
  bty='n')

#gender curves - literally no difference 
fit <- survfit(survival ~ animalSex, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#region curves - some difference 
fit <- survfit(survival ~ region, data = dogs)
plot(fit, lty=1:5, col = 2:6, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(region),
  lty=1:5,
  col=2:6,
  horiz=FALSE,
  bty='n')

#topic curves - 
fit <- survfit(survival ~ desc_latent_topic, data = dogs)
plot(fit, lty=1:10, col = 2:11, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(desc_latent_topic),
  lty=1:5,
  col=2:6,
  horiz=FALSE,
  bty='n')


#mostly_black curves - literally no difference 
fit <- survfit(survival ~ mostly_black, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)



names(dogs)

#discretizing data
dogs$animalBiggestPictures.cut <- cut(animalBiggestPictures, 
                                      breaks=unique(quantile(animalBiggestPictures, probs=seq(0,1,.25),include.lowest=T, na.rm=T)))
dogs$animalBiggestVideos.cut <- (dogs$animalBiggestVideos>0)+0
dogs$description_length.cut <- cut(description_length, 
                                   breaks=unique(quantile(description_length, probs=c(0,.5,.75,1),include.lowest=T)))

#having high quality images helps
ggsurv(survfit(survival ~ animalBiggestPictures.cut , data=dogs), plot.cens=F)

# this field probably doesnt help
ggsurv(survfit(survival ~ animalBiggestVideos.cut , data=dogs), plot.cens=F)

# there may be a sweet spot for description length
ggsurv(survfit(survival ~ description_length.cut , data=dogs), plot.cens=F)



#num search terms seems insignificant
dogs$search_string_num_terms.cut <- cut(search_string_num_terms, 
                                   breaks=unique(quantile(search_string_num_terms, probs=c(0,.5,.75,1),include.lowest=T)))
ggsurv(survfit(survival ~ search_string_num_terms.cut , data=dogs), plot.cens=F)

#more pictures significantly improves adoption time
dogs$animalNumPictures.cut <- cut(animalNumPictures, 
                                        breaks=unique(quantile(animalNumPictures, probs=c(0,.5,.75,1),include.lowest=T, na.rm=T)))
ggsurv(survfit(survival ~ animalNumPictures.cut , data=dogs), plot.cens=F)


#having a video really helps
dogs$animalNumVideos.cut <- cut(animalNumVideos, 
                                  breaks=c(-1,0,8))
ggsurv(survfit(survival ~ animalNumVideos.cut , data=dogs), plot.cens=F)


#more pictures significantly improves adoption time
dogs$animalAdoptionFee.cut <- cut(animalAdoptionFee, 
                                  breaks=unique(quantile(animalAdoptionFee, probs=c(0,.25, .5,.75,1),include.lowest=T, na.rm=T)))
ggsurv(survfit(survival ~ animalAdoptionFee.cut , data=dogs), plot.cens=F)


#current size not that influential
dogs$animalSizeCurrent.cut <- cut(animalSizeCurrent, 
                                  breaks=unique(quantile(animalSizeCurrent, probs=c(0,.25, .5,.75,1),include.lowest=T, na.rm=T)))
ggsurv(survfit(survival ~ animalSizeCurrent.cut , data=dogs), plot.cens=F)


#difference between small breeds and other; small breeds less desired (probably all the chihuahua)
dogs$animalSizePotential.cut <- cut(animalSizePotential, 
                                  breaks=unique(quantile(animalSizePotential, probs=c(0, .5,.75,1),include.lowest=T, na.rm=T)))
ggsurv(survfit(survival ~ animalSizePotential.cut , data=dogs), plot.cens=F)



names(dogs)


results <- coxph(survival ~  animalAdoptionFee + animalAltered +
                   animalBiggestPictures +  animalGeneralAge + animalGeneralSizePotential +
                   animalHousetrained + animalIndoorOutdoor + 
                   animalMicrochipped+ animalNeedsFoster +
                   animalNewPeople + animalNumPictures + animalNumVideos +
                   animalOKWithDogs + animalOKWithKids +
                  animalSex + animalSizeCurrent +
                  animalSpecialneeds + animalUptodate +
                   age_at_start + in_foster +
                   description_length + desc_latent_topic
                 + region + has_video + pitbull, data = dogs)
summary(results)
extractAIC(results)

zph <- cox.zph(results)
zph
plot(zph, col=3, var=46)
abline(h=0, lty=3, col=2)

mresid <- resid(results, type='martingale')
plot(mresid)

dresid <- resid(results, type='deviance')
plot(dresid)



exponential <- survreg(Surv(dogs$time_range, dogs$adopted) ~ animalAltered + animalMicrochipped + animalOKWithDogs +
                         in_foster + animalMixedBreed + animalActivityLevel +
                         animalGeneralAge + animalGeneralSizePotential + animalNewPeople + 
                         animalIndoorOutdoor + animalNumPictures + animalNumVideos + animalAdoptionFee,
                       dist = 'exponential')
summary(exponential)





