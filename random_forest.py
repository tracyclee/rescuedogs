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


def dummify(df, fields):
    for i, field in enumerate(fields):
        dummies = pd.get_dummies(df[field])
        cols = dummies.columns.values
        keep_cols = cols[1:]
        new_cols = ['{}_{}'.format(field, col) for col in keep_cols]
        df[new_cols] = dummies[keep_cols]
        del df[field]
    return df

if __name__ == '__main__':

    df = pd.read_csv('data/data_no_desc.csv')
    df = df[df['Adopted']==1]
    df.drop(['Adopted','Censored', 'Has_url', 'OrgID', 'Color', 'LocationState',
        'Breed', 'PrimaryBreed', 'SecondaryBreed', 'Start_Date', 'End_Date',
        'SearchString'], axis=1, inplace=True)
    df = dummify(df, ['ActivityLevel', 'GeneralAge', 'GeneralSizePotential', 'Housetrained',
        'IndoorOutdoor', 'Microchipped','NewPeople', 'OKWithCats', 'OKWithDogs', 'OKWithKids', 'Region',
        'Desc_Latent_Topic', 'Breed_Group', 'Sex'])


    y = df.pop('Time')
    X = df.values

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33)

    rf = RandomForestRegressor(n_estimators=500,
        min_samples_split= 1, max_depth= None, min_samples_leaf= 1)
    scores = cross_val_score(rf, X_train, y_train)
    print scores


    param_grid = {"max_depth": [3, None],
              "max_features": [1, 3, 10],
              "min_samples_split": [1, 3, 10],
              "min_samples_leaf": [1, 3, 10]}

    # run grid search
    grid_search = GridSearchCV(rf, param_grid=param_grid)
    grid_search.fit(X_train, y_train)
    print grid_search.best_score_
    print grid_search.best_params_
