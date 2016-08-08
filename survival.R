#load library
library(survival)

#load data
dogs <- read.csv('/Users/tracylee/raw_dogs/clean_without_text.csv')
attach(dogs)

# total survival curve
dogs.surv <- survfit(Surv(time_range, adopted)~ 1, conf.type="none")
plot(dogs.surv, xlab="Days Available", ylab="Percent Remaining")
title(main="Rescue Dog Survival Curve")

#limit to 1 year
plot(dogs.surv, xlab="Days Available", ylab="Percent Remaining", xlim=c(0,365))
title(main="Rescue Dog Survival Curve Within 1 Year")


dogs$survival <- Surv(dogs$time_range, dogs$adopted)

#altered curves - kinda different
group <- animalAltered + animalAlterUnknown
n <- 
fit <- survfit(survival ~ group, data = dogs)
plot(fit, lty = 1:2, mark.time = FALSE, xlab="Days Available", ylab="Percent Remaining")
legend(
  "topright",
  legend=unique(group),
  col=1:
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
