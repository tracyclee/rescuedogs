import pandas as pd
import numpy as np
import re

def load_data():
    '''
    Reads in several hundred csvs into pandas dataframes, concatenating them together.
    Then converts date fields into datetime format
    '''

    date_fields = [u'animalAdoptedDate','animalAvailableDate', u'animalBirthdate',
                u'animalFoundDate', u'animalKillDate',u'animalUpdatedDate', 'start_date', 'end_date']
    df = pd.read_csv('/Users/tracylee/raw_dogs/0.csv', parse_dates=date_fields)
    for i in xrange(1,827):
        df2 = pd.read_csv('/Users/tracylee/raw_dogs/{}.csv'.format(i), parse_dates=date_fields)
        df = pd.concat([df, df2])
        if i%25==0: print i
    df = df.sort(['animalOrgID','animalID'])
    df = df.reset_index()
    return df


def fewer_files(start, end):
    date_fields = [u'animalAdoptedDate','animalAvailableDate', u'animalBirthdate',
                u'animalFoundDate', u'animalKillDate',u'animalUpdatedDate']
    df = pd.read_csv('/Users/tracylee/raw_dogs/{}.csv'.format(start), parse_dates=date_fields)
    for i in xrange(start+1,end):
        df2 = pd.read_csv('/Users/tracylee/raw_dogs/{}.csv'.format(i), parse_dates=date_fields)
        df = pd.concat([df, df2])
        if i%25==0: print i
    df = df.reset_index()
    return df


def orgs_of_interest(df):
    '''
    Returns list of orgs that meet the basic criteria of having 10,000 lines of data
    '''
    org_df = df['animalOrgID'].value_counts()
    org_df = pd.DataFrame(org_df)
    org_df = org_df.reset_index()
    org_df.columns = ['OrgID', 'count']
    orgs_of_interest = org_df[org_df['count']>=10000]['OrgID'].values
    return orgs_of_interest

def start_end_date(df):
    '''
    Add columns for a start date and an end date.
    '''
    df['start_date'] = df.apply(start_date,axis=1)
    df['end_date'] = df.apply(end_date,axis=1)
    return df




def date_time(x):
    try:
        return pd.to_datetime(x)
    except:
        return np.nan


def start_date(row):
    '''
    Selects a start date from either the animal available date or animal found date.
    '''
    try:
        avail_date = pd.to_datetime(row['animalAvailableDate'])
    except:
        avail_date = np.nan
    try:
        found_date = pd.to_datetime(row['animalFoundDate'])
    except:
        found_date = np.nan

    if (not pd.isnull(avail_date) and not pd.isnull(found_date)):
        date_diff = (avail_date - found_date)
        if (date_diff.days>-10 and date_diff.days<300):
            return avail_date
    elif not pd.isnull(avail_date) and pd.isnull(found_date):
        return avail_date
    elif pd.isnull(found_date)==False and pd.isnull(avail_date):
        return found_date
    else:
        return np.nan

def end_date(row):
    '''
    Selects an end date from either the adopt date or kill date.
    '''
    try:
        adopt_date = pd.to_datetime(row['animalAdoptedDate'])
    except:
        adopt_date = np.nan
    try:
        kill_date = pd.to_datetime(row['animalKillDate'])
    except:
        kill_date = np.nan

    if not pd.isnull(adopt_date):
        return adopt_date
    elif not pd.isnull(kill_date):
        return kill_date
    else:
        return np.nan

def impute_dates_all(df, orgs_of_interest):
    '''
    Impute dates for each org, one by one.
    '''
    temp_df = impute_dates_one(df,orgs_of_interest[0])

    for org in orgs_of_interest[1:]:
        temp_df2 = impute_dates_one(df,org)
        temp_df = pd.concat([temp_df,temp_df2], axis=1)

    return temp_df

def impute_dates_one(df, org):
    '''
    Impute dates for one org.
    '''
    temp_df = df[df['animalOrgID']==org]
    dates = temp_df[pd.isnull(temp_df['start_date'])==False]['start_date'].values
    ids = temp_df[pd.isnull(temp_df['start_date'])==False]['animalID'].values

    if len(ids)<2:
        return None
    else:
        temp_df=temp_df[(temp_df['animalID']>ids.min()) & (temp_df['animalID']<ids.max())]
        temp_df['start_lower']=temp_df['animalID'].apply(lambda x: dates[np.argmax(x<ids)-1])
        temp_df['start_higher']=temp_df['animalID'].apply(lambda x: dates[np.argmax(x<=ids)])
        temp_df['start_diff'] = temp_df['start_higher'] - temp_df['start_lower']
        temp_df['start_diff'] = temp_df['start_diff'].apply(lambda x: x.days)
        temp_df['start_add'] = temp_df['start_diff']
        temp_df = temp_df[abs(temp_df['start_diff'])<=30]
        temp_df['start_add'] = pd.to_timedelta((temp_df['start_add']/2),unit='D')
        try:
            temp_df['start_date'] = temp_df['start_lower'] + temp_df['start_add']
        except:
            return None

    return temp_df

def middle_date(row):
    '''
    Calculates the midpoint between two dates.
    '''
    lower = row['start_lower']
    diff = (row['start_higher'] - row['start_lower'])/2
    return lower + diff

def labels(df):
    '''
    Create labels.
    '''
    df['killed'] = df[u'animalKillDate'].apply(lambda x: 0 if pd.isnull(x) else 1)
    df['adopted']= df['animalStatus'].apply(lambda x: 1 if x=='Adopted' else 0)
    df['censored'] = df['animalStatus'].apply(lambda x: 1 if x=='Available' else 0)
    df['time_range'] = (df['end_date']-df['start_date'])
    df['time_range'] = df['time_range'].apply(lambda x: x.days if pd.isnull(x)==False else np.nan)
    return df

def adoption_fee_parse(x):
    if pd.isnull(x):
        return np.nan
    else:
        regex = re.findall(r'\d+', x)
        if len(regex)>0:
            return sum([float(num) for num in regex])
        else:
            return np.nan

def dummify(df, fields, baselines):
    for i, field in enumerate(fields):
        dummies = pd.get_dummies(df[field])
        cols = dummies.columns.values
        keep_cols = cols[cols!=baselines[i]]
        new_cols = [field + "_"+ col_name for col_name in keep_cols]
        df[new_cols] = dummies[keep_cols]
        del df[field]
    return df

def add_unknown_column(df, fields):
    for field in fields:
        df[field+'Unknown']=df[field].apply(lambda x: 1 if pd.isnull(x) else 0)
        df[field].fillna(0,inplace=True)
    return df

def fill_na_mean(df, fields):
    for field in fields:
        df[field].fillna(df[field].mean(), inplace=True)
    return df

def fill_na_mode(df, fields):
    for field in fields:
        df[field].fillna(df[field].mode(), inplace=True)
    return df

def fill_na_10000(df, fields):
    for field in fields:
        df[field].fillna(10000, inplace=True)
    return df

def fill_with_unknown(df):
    fill_with_unknown= ['animalActivityLevel', u'animalGeneralAge', u'animalGeneralSizePotential',
            u'animalIndoorOutdoor',u'animalNewPeople',
            u'animalPrimaryBreed',
           u'animalSecondaryBreed']
    for field in fill_with_unknown:
        df[field].fillna("Unknown", inplace=True)
    return df

def state_to_region(x):
    West = ['CA','UT','WY','MT', 'OR','WA',
            'CO','AZ','NM','NV', 'AK', 'ID']
    Midwest = ['IL','MI','IN','MO', 'MN','KS',
              'OH','ND','WI', 'IA', 'SD','NE']
    South = ['TX','NC','MD', 'WV', 'KY', 'TN',
            'DE', 'OK','FL','LA', 'VA','SC',
            'GA', 'AL','AR','MS','DC']
    Northeast = ['PA','VT','NY','MA','NJ', 'RI',
                'ME','CT','NH']
    Canada = ['NS', 'ON', 'QC','AB','BC']
    Territory = ['VI','PR']

    region_names = ['West', 'Midwest', 'South', 'Northeast', 'Canada', 'Territory']
    regions = [West, Midwest, South, Northeast, Canada, Territory]
    for i, region in enumerate(regions):
        if x in region:
            return region_names[i]

def breed_groups(df):
    df['pitbull']=df[u'animalBreed'].apply(lambda x: 1 if 'pit bull' in x.lower()
                                                   else 1 if 'bull terrier' in x.lower()
                                                   else 1 if 'staffordshire' in x.lower()
                                                   else 1 if 'american bulldog' in x.lower()
                                                   else 1 if 'bully' in x.lower()
                                                   else 0)
    df['Terrier']=df[u'animalBreed'].apply(lambda x: 1 if 'terrier' in x.lower()
                                                   else 0)
    df['Hound']=df[u'animalBreed'].apply(lambda x: 1 if 'hound' in x.lower()
                                                     else 1 if 'hund' in x.lower()
                                                       else 0)
    df['Herding']=df[u'animalBreed'].apply(lambda x: 1 if 'herd' in x.lower()
                                                     else 1 if 'shep' in x.lower()
                                                    else 1 if 'sheep' in x.lower()
                                                       else 1 if 'corgi' in x.lower()
                                                       else 1 if 'collie' in x.lower()
                                                       else 0)
    df['Working']=df[u'animalBreed'].apply(lambda x: 1 if 'retriever' in x.lower()
                                                     else 1 if 'setter' in x.lower()
                                                    else 1 if 'spaniel' in x.lower()
                                                       else 1 if 'pointer' in x.lower()
                                                       else 0)
    return df


def impute_nan_size_and_age(df):
    df['tempAgeSize'] = df['GeneralAge'] + df['GeneralSizePotential']
    temp = df[['tempAgeSize', 'SizeCurrent', 'SizePotential']].groupby(['tempAgeSize']).agg(['mean'])
    temp.reset_index()
    temp.columns = temp.columns.get_level_values(0)
    temp.columns = ['tempAgeSize', 'SizeCurrent_mean', 'SizePotential_mean']
    result = pd.merge(test_df, temp, how='left', on=['tempAgeSize'])
    result['SizeCurrent'].fillna(result['SizeCurrent_mean'], inplace=True)
    result['SizePotential'].fillna(result['SizePotential_mean'], inplace=True)

    temp2 = df[['GeneralAge','Age_at_Start']].groupby(['GeneralAge']).agg(['mean'])
    temp2.reset_index()
    temp2.columns = temp2.columns.get_level_values(0)
    temp2.columns = ['GeneralAge', 'Age_at_Start_mean']
    result2 = pd.merge(result, temp2, how='left', on=['GeneralAge'])
    result2['Age_at_Start'].fillna(result2['Age_at_Start_mean'],inplace=True)

    result2.drop(['tempAgeSize', 'SizeCurrent_mean', 'SizePotential_mean', 'Age_at_Start_mean'], axis=1)

    return result2

if __name__ == '__main__':
    df = load_data()
    orgs_of_interest = orgs_of_interest(df)
    df = start_end_date(df)
    # df = impute_dates_all(df, orgs_of_interest)
    df = labels(df)

    df['animalBirthdate'] = df['animalBirthdate'].apply(lambda x: date_time(x))
    # df = dummify(df, ['animalAltered', 'animalDeclawed' 'animalIndoorOutdoor','animalNewPeople'])
    # df = add_unknown_column(df, ['animalHousetrained', 'animalMixedBreed', 'animalOKWithCats',
    #                         'animalOKWithDogs', 'animalOKWithKids', 'animalSpecialneeds', 'animalUptodate'])
    df = fill_na_mean(df, ['animalNumPictures', 'animalNumVideos'])
    df = fill_na_10000(df, ['animalSizeCurrent', 'animalSizePotential'])
    df['AdoptionFee'] = df['AdoptionFee'].apply(lambda x: adoption_fee_parse(x))
    df['mostly_black'] = df['animalColor'].apply(lambda x: 1 if str(x)[:5]=='Black' else 0)
    df['region'] = df['animalLocationState'].apply(lambda x: state_to_region(x))
    df['search_string_num_terms'] = df['animalSearchString'].apply(lambda x: len(str(x).split()))
    df['description_length'] = df['animalDescriptionPlain'].apply(lambda x: len(str(x)))
    df = impute_nan_size_and_age(df)
