what did I do

Monday:
- Made a lot of requests
- Went through each column to filter out the unneeded/likely empty values

Tuesday:
- attempted to thread
- set up EC2 instance to hackily double my download speed

Wednesday:
- feature engineering
- cleaning dates

Thursday:
- feature engineering
- choosing dates from mixed fields

Friday:
- filtering data down until clean
- Data is suspiciously lacking in kills.
- started modeling stuff in R

Saturday:
- dummifying data:
  - activity level: filled in nans with moderately active
  - adoption fee: regexed for values; took sums

Sunday:
- doing tons of stuff in R
- survival curves
  - best fields: [animalAltered + animalMicrochipped + animalOKWithDogs +
                  in_foster + animalMixedBreed + animalActivityLevel +
                  animalGeneralAge + animalGeneralSizePotential + animalNewPeople +
                  animalIndoorOutdoor + animalNumPictures + animalNumVideos + animalAdoptionFee]

Monday:
- looking at Cox evaluations; residuals; AIC
- zph validation of assumptions
- changed the data some more
- added latent topics
- binned states

Tuesday:
- what myths can I examine?
  - all the dogs are old - not true; more than half are baby/young (<=3)
  - adoption fees are too expensive
  - there are no purebreds - why does this matter; also 7% are known to be purebred
  - big dogs are worse with kids
  - difficult to adopt groups?
    - senior dogs
    - pit bull
    - special needs
    - black dogs


Wednesday:
- more group binning
- Story-telling:
  Context:
    - For my project, I decided to look at rescue pet data from the Rescue Groups API,
    which collects from rescue groups and shelters all across the country. I had hoped that
    I could derive some insights from the data that might help benefit the millions of animals
    that enter shelters every year, because I love dogs. In fact, my own dog Tess was a shelter dog
    who would have been euthanized if I hadn't adopted her, so I feel very strongly about this topic.

    I refined my focus to only one species--dogs--in this first pass, partially because there were more records
    for dogs, but mostly because I just love dogs the most.
    *show picture of Tess???*

  Process:
    - I approached this problem with survival analysis (also called duration analysis or accelerated life models) in mind. The top 3 reasons dogs are euthanized are illness, aggression, and space--and space is a constraint
    that can be alleviated through increasing animal turnaround. So I asked myself--how can we improve the adoptability
    of these dogs? What are the major relevant factors impacting the amount of time a dog will be up for adoption?

    *show survival curve*


    I initially started with some exploratory data analysis and followed my intuition about some of the factors
    that I thought would be most relevant to the topic. to see if I could confirm or disprove
    some of the beliefs about dog adoption.  

    For starters, 
  Results:

  Next Steps:
