# Stay!
Investigating Rescue Dogs Dataset
Tracy Lee, August 2016

##Contents:
* Motivation
* Data Overview
* Survival Models
* Random Forest


##Motivation
This projects begs the question: how can we use publicly available data to help rescue groups find homes for dogs? What can we divine from this information to make these groups better? And can we predict how long a dog will be up for adoption?

This project has personal significance for me because of this gorgeous girl, who would have been euthanized if I hadn't adopted her. She is the most beautiful and perfect dog in the world.

![Tess](/images/tess.jpg =300x)

With this information, we can optimize the already stretched thin resources that non-profits usually struggle. We can confirm that some widely held beliefs are true, while others are not. And, we can also identify great groups who can lead others by example or can shoulder some additional burden.


##Data Overview
For my project, I drew rescue pet data from the Rescue Groups API, which collects from rescue groups and shelters across the country. The data was extensive, with 1.6 million records for dogs and 141 features, but also messy and require substantial cleaning to parse fields. Notably, all fields were read in as strings and many required regular expression parsing (e.g. adoption fees may have said "$200 for spaying and $150 for relocation") to obtain clean values.

In terms of feature engineering, I tried to form sensible groupings for features with many categories. Breeds alone had thousands of unique combinations that I filtered down into
* Pitbulls
* Working
* Hound
* Herding
* Terrier

I also performed some natural language processing on the descriptions to group them by latent features:
* Adoption-focused
* Identification / Microchip-focused
* Specifying meeting or obtaining the dog at an event
* Emotional ones emphasis on characteristics (e.g. sweet and loving)

I was also curious after viewing a few rescue websites as to whether or not some rescues were simply better than others, aside from the data I had on dogs, so I went through and identified a few "good" and "bad" groups.


##Survival Analysis
Survival analysis, in brief, encompasses a number of models that analyze how long it will take until an event occurs. I started by modeling the survival curves of my data through Kaplan-Meier estimates. Kaplan-Meier is a non-parametric model of the time to event, whose advantage lies in its incorporation of censored data. The resulting survival curve plots the probability of duration exceeding a specific time.

![Pitbull Survival Curves](https://github.com/tracyclee/rescuedogs/blob/master/images/survival_curve_pitbull.jpeg)

For example, in this curve, about 63% of pitbulls are expected to be adopted within a 500 days of being up for adoption, but all else being equal, 75% of non-pitbulls would be expected to be adopted in that same time frame.

![Black Dog Survival Curves](https://github.com/tracyclee/rescuedogs/blob/master/images/survival_curve_black.jpeg)

On the other hand, the survival curves for black and non-black dogs are virtually indistinguishable. This contradicts the idea of "Black Dog Syndrome"--a widely held belief by shelter workers that black dogs are more disadvantaged than dogs of lighter colors.

To get a clearer idea of how individual features affect the time to event, I turned to the Cox Proportional Hazards model, a semi-parametric survival model. CoxPH measures the affect of covariates against the baseline hazard rate. CoxPH assumes the effects of the predictor variables upon survival are constant over time and are additive in one scale. My final model was created via stepwise feature selection in consultation with Akaike information criterion, given the profundity of features.

The high interpretability of the CoxPH model gives us insight into how rescues can be more effective in their resource allocation. Eminently feasible attributes include:
* Having a video
* Microchipping
* Socializing the dog to both other dogs and kids
* Keeping descriptions focused on adoption
* Keeping descriptions at a reasonable length (1000-1500 chars)

The model also helps identify at-risk populations. We can see that Pitbulls and special needs dogs are both in greater need of attention than young dogs, but what's non-trivially non-obvious is that Pitbulls are nearly as disadvantaged as special needs dogs.


##Random Forest
However, what if a rescue just wanted to know how long it would be, and didn't care about probabilities? I built an additional random forest to predict the number of days it would take for a dog to be adopted. Knowing the duration itself could have implications on budgeting, fundraising, and even fostering.

![Random Forest](https://github.com/tracyclee/rescuedogs/blob/master/images/rf_results.tiff)


##Future
In the future, two additional problems I'd like to work on are:
* Outcome classification. The dataset I had came from rescue groups, so the only real outcome was 'adoption', but shelters face more complicated outcomes including return to owner, transfer, death, and euthanasia.
* We could also extend the regression model into a cost prediction by factoring the operations and food a certain dog could expect to incur. This could be helpful both in budgeting and in setting appropriate target goals for fundraising.
