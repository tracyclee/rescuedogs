import pandas as pd
import statsmodels.api as sms
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats.kde import gaussian_kde
import seaborn as sns


def time_histogram(df):
    '''
    INPUT: df
    OUTPUT: none

    Creates histogram of times.
    '''
    plt.hist(df['time_range'], normed=1, bins=500, alpha=0.4, edgecolor='none')
    plt.xlim(0,100)
    plt.title('Time Distribution')
    plt.ylabel('Probability Density', fontsize=14)
    plt.xlabel('Number of Days', fontsize=14)
    plt.show()


def plot_breed_trends(df):
    '''
    INPUT: df
    OUTPUT: none

    Creates boxplots of times by breed.
    '''
    top_20_breeds = df['animalPrimaryBreed'].value_counts().index[:20]
    plt.subplots(figsize=(15, 8))
    lst = [df[df['animalPrimaryBreed']==breed]['time_range'] for breed in top_20_breeds]
    plt.boxplot(lst, labels=top_20_breeds)
    plt.ylim(0, 2000)
    plt.xlabel('Breed', fontsize=14)
    plt.ylabel('Adoption time', fontsize=14)
    plt.xticks(rotation=60)
    plt.show()

def plot_pitbull(df):
    '''
    INPUT: df
    OUTPUT: none

    Creates boxplots of times by pitbulls vs all and others.
    '''
    plt.subplots(figsize=(15, 8))
    lst = [df['time_range'], df[df['pitbull']==1]['time_range'], df[df['pitbull']==0]['time_range']]
    plt.boxplot(lst, labels=['All', 'Pit Bull Family', 'Other'])
    plt.ylim(0, 1500)
    plt.ylabel('Adoption time', fontsize=20)
    plt.title('Time By Family', fontsize=24)
    plt.xticks(fontsize=14)
    plt.show()

def plot_color_trends(df):
    '''
    INPUT: df
    OUTPUT: none

    Creates boxplots of times by black vs all and others.
    '''
    plt.subplots(figsize=(15, 8))
    lst = [df['time_range'], df[df['mostly_black']==1]['time_range'], df[df['mostly_black']==0]['time_range']]
    plt.boxplot(lst, labels=['All', 'Black', 'Other Color'])
    plt.ylim(0, 1500)
    plt.ylabel('Adoption time', fontsize=20)
    plt.title('Time By Color', fontsize=24)
    plt.xticks(fontsize=14)

def plot_all_region_trends(df):
    '''
    INPUT: df
    OUTPUT: none

    Creates boxplots of time by regions.
    '''
    region_names = ['West', 'Midwest', 'South', 'Northeast', 'Canada']
    regions = ["{}\n{}".format(region, df[df['region']==region]['time_range'].count())
               for region in region_names]
    plt.subplots(figsize=(15, 8))
    lst = [df[df['region']==region]['time_range'] for region in region_names]
    plt.boxplot(lst, labels=regions)
    plt.ylim(0, 2500)
    plt.xlabel('Region and Number of Records',fontsize=20)
    plt.ylabel('Adoption time', fontsize=20)
    plt.title('Time By Region', fontsize=24)
    plt.xticks(fontsize=14)
    plt.show()

def plot_one_region(df, region_name, region_states):
    '''
    INPUT: df, string, list
    OUTPUT: none

    Creates boxplots of time by the states within a designated region.
    '''
    regions = ["{}\n{}".format(region, df[df['animalLocationState']==region]['time_range'].count())
               for region in region_states]
    plt.subplots(figsize=(15, 8))
    lst = [df[df['animalLocationState']==region]['time_range'] for region in region_states]
    plt.boxplot(lst, labels=regions)
    plt.ylim(0, 2500)
    plt.ylabel('Adoption time', fontsize=20)
    plt.xlabel('State and Number of Records',fontsize=20)
    plt.title('Time By States in {}'.format(region_name), fontsize=24)
    plt.xticks(fontsize=14)
    plt.show()

def plot_age_groups(df):
    '''
    INPUT: df
    OUTPUT: none

    Creates bar graphs of perecent of animal by age that enter shelters.
    '''

    objects = ['Baby', 'Young', 'Adult', 'Senior', 'Unknown']
    y_pos = np.arange(len(objects))
    performance = [1.*(df['animalGeneralAge']==object).sum()/df.shape[0] for object in objects]

    plt.subplots(figsize=(15, 8))
    plt.bar(y_pos, performance, align='center', alpha=0.5)
    plt.xticks(y_pos, objects, fontsize=20)
    plt.yticks(fontsize=14)
    plt.ylabel('Percent of Observations', fontsize=20)
    plt.title('Age Groups', fontsize=24)

def median_records_scatter(df):
    '''
    INPUT: df
    OUTPUT: none

    Creates scatter chart of organizations by number of records and median duration of dog.
    '''

    df['animalLocationState'] = df['animalLocationState']
    temp = df[['animalOrgID','animalLocationState','time_range']].groupby(['animalOrgID','animalLocationState',]).agg(['median', 'count'])
    temp = temp.reset_index()
    org = temp['animalOrgID']
    state = temp['animalLocationState']
    mean = temp['time_range','median']
    count = temp['time_range','count']

    colors = pd.tools.plotting._get_standard_colors(len(temp['animalLocationState'].unique()), color_type='random')
    fig, ax = plt.subplots(figsize=(15, 8))
    plt.xlim(0, 500)
    plt.ylim(0, 3500)
    plt.ylabel('Median Adoption Time', fontsize=20)
    plt.xlabel('Number of Records',fontsize=20)
    plt.title('', fontsize=24)
    plt.scatter(count,mean, s = count, c=colors, alpha=.4)
    ax.set_color_cycle(colors)
    for i, txt in enumerate(state):
        if count[i] > 300 and mean[i] < 200:
            ax.annotate(txt, (count[i],mean[i]))
        elif count[i] > 200 and mean[i] > 200:
            ax.annotate(txt, (count[i],mean[i]))


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
