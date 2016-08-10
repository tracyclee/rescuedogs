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
  - all the dogs are old
  - adoption fees are too expensive
  - there are no purebreds
  - big dogs are worse with kids
  - difficult to adopt groups?
    - senior dogs
    - pit bull
    - special needs
    - black dogs
