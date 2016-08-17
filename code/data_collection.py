import pandas as pd
import numpy as np
import threading
import sys
import requests
import json
from os import path
import csv


def request_to_csv(i, batch_size):
    link = "https://api.rescuegroups.org/http/v2.json"
    api_key = 'ZJJi3YFv'

    kept_fields = [u'animalActivityLevel',"animalSizeUOM", u'animalAdoptedDate',
               u'animalAdoptionFee', u'animalAdoptionPending', u'animalAltered', u'animalAvailableDate',
               u'animalBirthdate', u'animalBreed',  u'animalColor', u'animalColorDetails', u'animalDeclawed',
               u'animalDescription', u'animalDescriptionPlain',  u'animalFound', u'animalFoundDate',  u'animalGeneralAge',
               u'animalGeneralSizePotential',  u'animalHousetrained',  u'animalID',  u'animalIndoorOutdoor',  u'animalKillDate',
               u'animalKillReason',  u'animalLocation',  u'animalLocationState', u'animalMicrochipped', u'animalMixedBreed',
               u'animalName', u'animalNeedsFoster', u'animalNewPeople',   u'animalOKWithCats', u'animalOKWithDogs',
               u'animalOKWithKids', u'animalOrgID', u'animalPictures', u'animalPrimaryBreed', u'animalRescueID',
               u'animalSearchString', u'animalSecondaryBreed', u'animalSex', u'animalSizeCurrent', u'animalSizePotential',
               u'animalSpecialneeds', u'animalSpecialneedsDescription', u'animalStatus', u'animalStatusID', u'animalSummary',
               u'animalUpdatedDate', u'animalUptodate', u'animalUrl', u'animalVideos', u'fosterName',
               u'locationState', u'locationUrl']
    myhead = [u'animalActivityLevel', u'animalAdoptedDate',
            u'animalAdoptionFee', u'animalAdoptionPending', u'animalAltered',
            u'animalAvailableDate', 'animalBiggestPictures', 'animalBiggestVideos',
            u'animalBirthdate', u'animalBreed', u'animalColor', u'animalColorDetails',
            u'animalDeclawed', u'animalDescription', u'animalDescriptionPlain', u'animalFound',
            u'animalFoundDate', u'animalGeneralAge', u'animalGeneralSizePotential',
            u'animalHousetrained', u'animalID', u'animalIndoorOutdoor', u'animalKillDate',
            u'animalKillReason', u'animalLocation', u'animalLocationState',
            u'animalMicrochipped', u'animalMixedBreed', u'animalName', u'animalNeedsFoster',
            u'animalNewPeople', 'animalNumPictures', 'animalNumVideos', u'animalOKWithCats',
            u'animalOKWithDogs', u'animalOKWithKids', u'animalOrgID', u'animalPrimaryBreed',
            u'animalRescueID', u'animalSearchString', u'animalSecondaryBreed', u'animalSex',
            u'animalSizeCurrent', u'animalSizePotential', u'animalSizeUOM', u'animalSpecialneeds',
            u'animalSpecialneedsDescription', u'animalStatus', u'animalStatusID', u'animalSummary',
            u'animalUpdatedDate', u'animalUptodate', u'animalUrl', u'animalVideoUrls', u'fosterName',
            u'locationState', u'locationUrl']
    result = requests.post(link, json = {"apikey":api_key,
        "objectType":"animals",
        "objectAction":"publicSearch",
        "search" :{
            "calcFoundRows" : "Yes",
            "resultStart": i*batch_size,
            "resultLimit": batch_size,
            "resultSort" : "animalID",
            "fields" : kept_fields,
            "filters": [{
                "fieldName": "animalSpecies",
                "operation": "equals",
                "criteria": "Dog",
                },
                        {
                "fieldName": "animalSizeUOM",
                "operation": "notequals",
                "criteria": "Centimeters",
                }
                       ]
            }})

    if result.status_code != 200 or result.json()['status']=='error':
        pass
    else:
        mypath = path.expanduser('~/raw_dogs/%s.csv' % i)
        with open(mypath, 'w+') as f:
            spamWriter = csv.DictWriter(f, myhead, extrasaction='ignore')
            spamWriter.writeheader()
            for animal, a_data in result.json()['data'].iteritems():
                for medium in ['Pictures', 'Videos']:
                    p_sizes = [int(x.get('fileSize', 0)) for x in a_data.get('animal%s' % medium, [])]
                    a_data['animalBiggest%s' % medium] = max(p_sizes) if p_sizes else 0
                    a_data['animalNum%s' % medium] = len(p_sizes)
                    try:
                        a_data.pop('animal%s' % medium)
                    except:
                        pass
                a_data = {k:v.encode('utf8') if isinstance(v, basestring) else v for k,v in a_data.iteritems()}
                spamWriter.writerow(a_data)




if __name__ == '__main__':
    jobs = []
    batch_size = 2000

    ct = 1643122
    num_batches = (ct / batch_size) + 1
    trial = 501

    for num in range(trial, num_batches):
        request_to_csv(num, batch_size)
