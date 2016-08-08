import pandas as pd
import numpy as np
from pandas.tseries.offsets import *

def load_data():
    '''
    Reads in several hundred csvs into pandas dataframes, concatenating them together.
    Then converts date fields into datetime format
    '''

    date_fields = [u'animalAdoptedDate','animalAvailableDate', u'animalBirthdate',
                u'animalFoundDate', u'animalKillDate',u'animalUpdatedDate']
    df = pd.read_csv('/Users/tracylee/raw_dogs/0.csv', parse_dates=date_fields)
    for i in xrange(1,10):
        df2 = pd.read_csv('/Users/tracylee/raw_dogs/{}.csv'.format(i), parse_dates=date_fields)
        df = pd.concat([df, df2])
    df = df.sort(['animalOrgID','animalID'])

    # df = df.reset_index()
    return df

def orgs_of_interest(df):
    org_df = df['animalOrgID'].value_counts()
    org_df = pd.DataFrame(org_df)
    org_df = org_df.reset_index()
    org_df.columns = ['OrgID', 'count']
    orgs_of_interest = org_df[org_df['count']>=100]['OrgID'].values
    return orgs_of_interest

def start_end_date(df):
    df['start_date'] = df.apply(start_date,axis=1)
    df['end_date'] = df.apply(end_date,axis=1)
    return df


def impute_dates_all(df, orgs_of_interest):
    temp_df = impute_dates_one(df,orgs_of_interest[0])

    for org in orgs_of_interest[1:]:
        print "org--------", org
        temp_df2 = impute_dates_one(df,org)
        temp_df = pd.concat([temp_df,temp_df2], axis=1)

    return temp_df
#
def start_date(row):
    avail_date = row['animalAvailableDate']
    found_date = row['animalFoundDate']

    if (not pd.isnull(avail_date) and not pd.isnull(found_date)):
        date_diff = (avail_date - found_date)
        if (date_diff.days>-10 and date_diff.days<300):
            return avail_date
    elif not pd.isnull(avail_date):
        return avail_date
    elif pd.isnull(found_date)==False:
        return found_date
    else:
        return np.nan
#
def end_date(row):
    adopt_date = row['animalAdoptedDate']
    kill_date = row['animalKillDate']

    if not pd.isnull(adopt_date):
        return adopt_date
    elif not pd.isnull(kill_date):
        return kill_date
    else:
        return np.nan
#
def label(row):
    if row['animalFoundDate']!='nothing':
        return row['animalFoundDate']
    else:
        bounds = date_pairs[np.array([((row['level_0']<pair[1]) and (row['level_0']>=pair[0])) for pair in index_pairs])][0]
        return bounds[0] + (bounds[1]-bounds[0])/2
#
def impute_dates_one(df, org):
    temp_df = df[df['animalOrgID']==org]
    dates = temp_df[pd.isnull(temp_df['start_date'])==False]['start_date']
    indices = dates.index

    if len(indices)<2:
        return None
    else:
        index_pairs = [(i,j) for i, j in zip(indices[:-1], indices[1:])]
        date_pairs = np.array([(i,j) for i, j in zip(dates[:-1], dates[1:])])
        diffs = np.array([(j-i).days for i, j in zip(dates[:-1], dates[1:])])

        temp_df['date_diff'] = temp_df['index'].apply(lambda x: 9999
            if (x<indices[0] or x>indices[-1])
            else diffs[np.array([((x <= pair[1])
                and (x >= pair[0])) for pair in index_pairs])][0])
        temp_df = temp_df[abs(temp_df['date_diff'])<=30]
        temp_df['start_date'] = temp_df.apply(label, axis=1)
    return temp_df
#
#
#
#

def labels(df):
    df['killed'] = df[u'animalKillDate'].apply(lambda x: 1 if not pd.isnull(x) else 0)
    df['adopted']= df['animalStatus'].apply(lambda x: 1 if x=='Adopted' else 0)
    df['censored'] = df['animalStatus'].apply(lambda x: 1 if x=='Available' else 0)
    df['time_range'] = (df['end_date']-df['start_date'])
    df['time_range'] = df['time_range'].apply(lambda x: x.days)
    return df



if __name__ == '__main__':
    df = load_data()
    orgs_of_interest = orgs_of_interest(df)
    df = start_end_date(df)
    df = impute_dates_all(df, orgs_of_interest)
    df = labels(df)
