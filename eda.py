import pandas as pd
import statsmodels.api as sms
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats.kde import gaussian_kde
import seaborn as sns


def time_histogram(df):
    plt.hist(df['time_range'], normed=1, bins=500, alpha=0.4, edgecolor='none')
    plt.xlim(0,100)
    plt.title('Time Distribution')
    plt.ylabel('Probability Density', fontsize=14)
    plt.xlabel('Number of Days', fontsize=14)
    plt.show()


def plot_breed_trends(df):
    top_20_breeds = df['animalPrimaryBreed'].value_counts().index[:20]
    plt.subplots(figsize=(15, 8))
    lst = [df[df['animalPrimaryBreed']==breed]['time_range'] for breed in top_20_breeds]
    plt.boxplot(lst, labels=top_20_breeds)
    plt.ylim(0, 2000)
    plt.xlabel('Breed', fontsize=14)
    plt.ylabel('Adoption time', fontsize=14)
    plt.xticks(rotation=60)
    plt.show()



if __name__ == '__main__':

binary_fields = [u'animalAltered',u'animalDeclawed', u'animalHousetrained',
       u'animalMicrochipped', u'animalMixedBreed', u'animalNeedsFoster',
       u'animalOKWithCats', u'animalOKWithDogs', u'animalOKWithKids',
       u'animalSpecialneeds', u'animalUptodate',
       u'in_foster', u'Highly Active', u'Not Active',
       u'Slightly Active', u'animalAlterUnknown', u'animalDeclawedUnknown',
       u'animalMicrochippedUnknown', u'Adult', u'Baby', u'Senior', u'Young',
       u'Large', u'Medium', u'Small', u'X-Large', u'Indoor Only',
       u'Indoor and Outdoor', u'Outdoor Only', u'Aggressive', u'Cautious',
       u'Friendly', u'Protective', u'animalHousetrainedUnknown',
       u'animalMixedBreedUnknown', u'animalOKWithCatsUnknown',
       u'animalOKWithDogsUnknown', u'animalOKWithKidsUnknown',
       u'animalSpecialneedsUnknown', u'animalUptodateUnknown', u'mostly_black',
       u'sex_male']

continuous_fields = [u'animalAdoptionFee',u'animalBiggestPictures',
       u'animalBiggestVideos', u'animalNumPictures', u'animalNumVideos',
       u'animalSizeCurrent', u'animalSizePotential', u'age_at_start',
       u'description_length',u'search_string_num_terms']

label = 'time_range'



corr=df[continuous_fields+['time_range']].corr()

sns.heatmap(corr)
