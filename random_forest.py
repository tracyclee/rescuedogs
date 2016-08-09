import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.cross_validation import train_test_split, cross_val_score



def feature_importances():
    plt.figure()
    plt.title("Feature importances")
    plt.bar(range(10), importances[indices[-10:]], color="r", align="center")
    plt.xticks(range(10), df.columns[indices][-10:])
    plt.xticks(rotation=60)
    plt.xlim([-1, 10])
    plt.show()

if __name__ == '__main__':

df = pd.read_csv('/Users/tracylee/raw_dogs/clean_without_text.csv')
df = df[df['adopted']==1]
df.drop(['adopted','censored', 'tempAge', 'has_url', 'sex_male',
         u'animalBiggestVideos', 'animalOrgID'], axis=1, inplace=True)


y = df.pop('time_range')
# df = df[[u'animalAdoptionFee', u'animalAltered',
#        u'animalMicrochipped', u'animalNumPictures', u'animalNumVideos',
#        u'animalOKWithDogs', u'animalSizePotential',
#        u'age_at_start', u'in_foster', u'Highly Active', u'Not Active', u'Slightly Active',
#        u'animalAlterUnknown',
#        u'animalMicrochippedUnknown', u'Adult', u'Baby', u'Senior', u'Young',
#        u'Large', u'Medium', u'Small', u'X-Large', u'Indoor Only',
#        u'Indoor and Outdoor', u'Outdoor Only',
#        u'animalOKWithDogsUnknown',  u'mostly_black',
#        u'search_string_num_terms', u'description_length']]
X = df.values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33)

rf = RandomForestRegressor(n_estimators=100)
scores = cross_val_score(rf, X_train, y_train)
print scores
