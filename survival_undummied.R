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
dogs <- read.csv('/Users/tracylee/Documents/galvanize/capstone/data/data_no_desc.csv')
attach(dogs)

summary(dogs)

# total survival curve
dogs.surv <- survfit(Surv(Time, Adopted)~ 1, conf.type="none")
ggsurv(dogs.surv, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)
abline(h=.3, lty = 2, col = 3)
title(main="Rescue Dog Survival Curve")

#limit to 1 year
yearplot <- ggsurv(dogs.surv, xlab="Days Available", ylab="Percent Remaining", plot.cens=F)
yearplot  + coord_cartesian(xlim = c(0, 365))
abline(h=.27, lty = 2, col = 3)
title(main="Rescue Dog Survival Curve Within 1 Year")



dogs$survival <- Surv(dogs$Time, dogs$Adopted)

#altered curves - kinda different
fit <- survfit(survival ~ Altered, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#declawed curves - kinda different; declawed too low should expunge
fit <- survfit(survival ~ Declawed, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#housetrained curves - no difference
fit <- survfit(survival ~ Housetrained, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#microchipped curves - huge difference = most likely indicates a dog that has an owner who will come looking for him/her
fit <- survfit(survival ~ Microchipped, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#ok with cats curves - no difference
fit <- survfit(survival ~ OKWithCats, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#ok with dogs curves - significant difference
fit <- survfit(survival ~ OKWithDogs, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#ok with kids curves - little difference
fit <- survfit(survival ~ OKWithKids, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#specialneeds curves - little difference
fit <- survfit(survival ~ Specialneeds, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#in foster curves - some difference
fit <- survfit(survival ~ in_foster , data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#mixedbreed curves - initially no difference
fit <- survfit(survival ~ MixedBreed, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#needs foster curves - little difference
fit <- survfit(survival ~ NeedsFoster, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)


#activity curves -  difference - sedentary is bad
fit <- survfit(survival ~ ActivityLevel, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)


#agegroup curves - difference in first 100 days
fit <- survfit(survival ~ GeneralAge, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)


#agegroup curves - difference in first 100 days
fit <- survfit(survival ~ GeneralSizePotential, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)


#newpeople curves - huge difference 
fit <- survfit(survival ~ NewPeople, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)



#indoor outdoor curves - huge difference 
fit <- survfit(survival ~ IndoorOutdoor, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#gender curves - literally no difference 
fit <- survfit(survival ~ Sex, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#region curves - some difference 
fit <- survfit(survival ~ Region, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#topic curves - 
fit <- survfit(survival ~ Desc_Latent_Topic, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)


#mostly_black curves - literally no difference 
fit <- survfit(survival ~ Mostly_Black, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#Bad to be a Pitbull
fit <- survfit(survival ~ Pitbull , data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#bad, because includes pit bulls
fit <- survfit(survival ~ Terrier, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#people love bounds
fit <- survfit(survival ~ Hound, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#not a huge difference
fit <- survfit(survival ~ Working, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#no difference at all
fit <- survfit(survival ~ Herding, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)

#Bad to be a pitbull. People love hounds
fit <- survfit(survival ~ Breed_Group, data = dogs)
ggsurv(fit, xlab="Days Available", ylab="Percent Remaining", plot.cens=FALSE)



#discretizing data
dogs$BiggestPictures.cut <- cut(BiggestPictures, 
                                      breaks=c(-1, 400000, 600000, 1000000))
dogs$BiggestVideos.cut <- (dogs$BiggestVideos>0)+0
dogs$Description_Length.cut <- cut(description_length, 
                                   breaks=unique(quantile(description_length, probs=c(0,.5,.75,1),include.lowest=T)))

#having high quality images helps
ggsurv(survfit(survival ~ BiggestPictures.cut , data=dogs), plot.cens=F)

# this field probably doesnt help
ggsurv(survfit(survival ~ BiggestVideos.cut , data=dogs), plot.cens=F)

# there may be a sweet spot for description length
ggsurv(survfit(survival ~ Description_Length.cut , data=dogs), plot.cens=F)



#num search terms seems insignificant
dogs$Search_String_Num_Terms.cut <- cut(Search_String_Num_Terms, 
                                   breaks=c(-1,5,10,15, 100))
ggsurv(survfit(survival ~ Search_String_Num_Terms.cut , data=dogs), plot.cens=F)


#num search terms seems insignificant
dogs$Description_Length.cut <- cut(Description_Length, 
                                        breaks=c(-1,500,1000,1500,20000))
ggsurv(survfit(survival ~ Description_Length.cut , data=dogs), plot.cens=F)




#more pictures significantly improves adoption time
dogs$NumPictures.cut <- cut(NumPictures, 
                                        breaks=c(-1,0,2, 4,100))
ggsurv(survfit(survival ~ NumPictures.cut , data=dogs), plot.cens=F)


#having a video really helps
dogs$NumVideos.cut <- cut(NumVideos, 
                                  breaks=c(-1,0,10))
ggsurv(survfit(survival ~ NumVideos.cut , data=dogs), plot.cens=F)


#more expensive seems better; but probably signal of good shelter
dogs$AdoptionFee.cut <- cut(AdoptionFee, 
                                  breaks=unique(quantile(AdoptionFee, probs=c(0,.25, .5,.75,1),include.lowest=T, na.rm=T)))
ggsurv(survfit(survival ~ AdoptionFee.cut , data=dogs), plot.cens=F)


#current size not that influential
dogs$SizeCurrent.cut <- cut(SizeCurrent, 
                                  breaks=c(-1, 10, 25, 10000))
ggsurv(survfit(survival ~ SizeCurrent.cut , data=dogs), plot.cens=F)


#difference between small breeds and other; small breeds less desired (probably all the chihuahua)
dogs$SizePotential.cut <- cut(SizePotential, 
                                  breaks=unique(quantile(SizePotential, probs=c(0, .5,.75,1),include.lowest=T, na.rm=T)))
ggsurv(survfit(survival ~ SizePotential.cut , data=dogs), plot.cens=F)


dogs$Desc_Latent_Topic.cut <- cut(Desc_Latent_Topic, 
                                    breaks=c(-1, 0,1,2,3))
ggsurv(survfit(survival ~ Desc_Latent_Topic.cut , data=dogs), plot.cens=F)



names(dogs)

#ALL FEATURES
results <- coxph(survival ~  Breed_Group
                  +Desc_Latent_Topic.cut + Description_Length.cut+
                 + GeneralAge + GeneralSizePotential + Specialneeds
                  + In_Foster + Housetrained + GoodShelter + BadShelter + MixedBreed
                + Mostly_Black + Age_at_Start + OKWithCats + OKWithDogs + OKWithKids
                + Region + NumPictures.cut + NewPeople
                 + NeedsFoster + ActivityLevel
                + AdoptionFee + Altered +   Declawed
                + IndoorOutdoor + Microchipped
                + BiggestPictures.cut + BiggestVideos.cut
                +Declawed + Uptodate + Has_Video
                + Search_String_Num_Terms.cut
                + SizeCurrent.cut
               , data = dogs)
summary(results)
extractAIC(results)

#FORWARD STEP AIC MODEL FEATURE SELECTION


results <- coxph(survival ~  Pitbull+ Microchipped
                 +Desc_Latent_Topic.cut + Description_Length.cut+
                   + GeneralAge + GeneralSizePotential + Specialneeds
           + Housetrained 
           + GoodShelter + BadShelter  + MixedBreed
            + Mostly_Black 
           + Age_at_Start
           + OKWithCats + OKWithDogs + OKWithKids
              + Region + NumPictures.cut + NewPeople
               + NeedsFoster 
           + ActivityLevel
                + AdoptionFee + Altered 
                 + IndoorOutdoor 
           + BiggestVideos.cut
                 + Uptodate
                + Search_String_Num_Terms.cut
                 + SizeCurrent.cut
                 , data = dogs)
summary(results)
extractAIC(results)



survfit(results,newdata= dogs)


library(CoxBoost)

zph <- cox.zph(results)
zph
plot(zph, col=3, var=46)
abline(h=0, lty=3, col=2)

mresid <- resid(results, type='martingale')
plot(mresid)

dresid <- resid(results, type='deviance')
plot(dresid)



exponential <- survreg(Surv(dogs$time_range, dogs$adopted) ~ Altered + Microchipped + OKWithDogs +
                         in_foster + MixedBreed + ActivityLevel +
                         GeneralAge + GeneralSizePotential + NewPeople + 
                         IndoorOutdoor + NumPictures + NumVideos + AdoptionFee,
                       dist = 'exponential')
summary(exponential)





