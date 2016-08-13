Outline:

5-7 slides



Motivation (30 secs):
- I like dogs
- I adopted a shelter dog. Dog is great.
- I'm interested in figuring out what makes a dog get adopted faster
- Are there things shelters could do more? Are there model citizens?

Dataset (1min):
- Scraped from a Rescue Dogs api with an EC2 instance
- Feature engineering:
  - 141 features
  - NLP (TFIDF & NMF) to discern latent features
  - Breed Grouping
  - Region grouping
  - regular expression to parse fields that should have been numbers

  Model citizen; very Briefly

Model (1min):
- Briefly explain survival analysis
- Show some survival curves
- Show CoxPH Results
- talk about stepwise selection through AIC
  - use AIC because there isnt adjusted r2
- Discuss

- Random Forest:
  - I chose the Cox proportional hazards for its strength in interpretability, which was very important for my goal of discerning the effects of the most important features.
  Initial cross_val score without text: .700
  After adding NLP latent topics: .717
  After grid search: 


Next Steps:
- cost prediction per dog
- getting more outcomes; classification

Appendix:







Priorities:
- fill in those nans!!!!!!!!!?!??!?!!!!!!!!!!
- stepwise AIC
- run the cox prediction
- random forest
- coxBoost (max 30 mins)
- run the Kaggle competition data


Darren: (732) 865-3326
