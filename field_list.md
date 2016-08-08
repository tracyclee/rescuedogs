all_fields= [u'animalActivityLevel', u'animalAdoptedDate', u'animalAdoptionFee', u'animalAdoptionPending', u'animalAffectionate', u'animalAgeString', u'animalAltered', u'animalApartment', u'animalAvailableDate', u'animalBirthdate', u'animalBirthdateExact', u'animalBreed', u'animalCoatLength', u'animalColor', u'animalColorDetails', u'animalColorID', u'animalCourtesy', u'animalCratetrained', u'animalDeclawed', u'animalDescription', u'animalDescriptionPlain', u'animalDistinguishingMarks', u'animalDrools', u'animalEagerToPlease', u'animalEarType', u'animalEnergyLevel', u'animalEscapes', u'animalEventempered', u'animalExerciseNeeds', u'animalEyeColor', u'animalFence', u'animalFetches', u'animalFound', u'animalFoundDate', u'animalFoundPostalcode', u'animalGeneralAge', u'animalGeneralSizePotential', u'animalGentle', u'animalGoodInCar', u'animalGoofy', u'animalGroomingNeeds', u'animalHasAllergies', u'animalHearingImpaired', u'animalHousetrained', u'animalHypoallergenic', u'animalID', u'animalIndependent', u'animalIndoorOutdoor', u'animalIntelligent', u'animalKillDate', u'animalKillReason', u'animalLap', u'animalLeashtrained', u'animalLocation', u'animalLocationCitystate', u'animalLocationCoordinates', u'animalLocationDistance', u'animalLocationState', u'animalMicrochipped', u'animalMixedBreed', u'animalName', u'animalNeedsCompanionAnimal', u'animalNeedsFoster', u'animalNewPeople', u'animalNoCold', u'animalNoFemaleDogs', u'animalNoHeat', u'animalNoLargeDogs', u'animalNoMaleDogs', u'animalNoSmallDogs', u'animalNotHousetrainedReason', u'animalOKForSeniors', u'animalOKWithAdults', u'animalOKWithCats', u'animalOKWithDogs', u'animalOKWithFarmAnimals', u'animalOKWithKids', u'animalObedienceTraining', u'animalObedient', u'animalOlderKidsOnly', u'animalOngoingMedical', u'animalOrgID', u'animalOwnerExperience', u'animalPattern', u'animalPatternID', u'animalPictures', u'animalPlayful', u'animalPlaysToys', u'animalPredatory', u'animalPrimaryBreed', u'animalPrimaryBreedID', u'animalProtective', u'animalRescueID', u'animalSearchString', u'animalSecondaryBreed', u'animalSecondaryBreedID', u'animalSex', u'animalShedding', u'animalSightImpaired', u'animalSizeCurrent', u'animalSizePotential', u'animalSizeUOM', u'animalSkittish', u'animalSpecialDiet', u'animalSpecialneeds', u'animalSpecialneedsDescription', u'animalSpecies', u'animalSpeciesID', u'animalSponsorable', u'animalSponsors', u'animalSponsorshipDetails', u'animalSponsorshipMinimum', u'animalStatus', u'animalStatusID', u'animalSummary', u'animalSwims', u'animalTailType', u'animalThumbnailUrl', u'animalTimid', u'animalUpdatedDate', u'animalUptodate', u'animalUrl', u'animalVideoUrls', u'animalVideos', u'animalVocal', u'animalYardRequired', u'fosterEmail', u'fosterFirstname', u'fosterLastname', u'fosterName', u'fosterPhoneCell', u'fosterPhoneHome', u'fosterSalutation', u'locationAddress', u'locationCity', u'locationCountry', u'locationName', u'locationPhone', u'locationPostalcode', u'locationState', u'locationUrl']

*KEPT FIELDS*

u'animalSizeUOM',  I SHOULD SET THIS TO "Pounds"

kept_fields = [u'animalActivityLevel', u'animalAdoptedDate', u'animalAdoptionFee', u'animalAdoptionPending', u'animalAltered', u'animalAvailableDate', u'animalBirthdate', u'animalBreed',  u'animalColor', u'animalColorDetails', u'animalDeclawed', u'animalDescription', u'animalDescriptionPlain',  u'animalFound', u'animalFoundDate',  u'animalGeneralAge', u'animalGeneralSizePotential',  u'animalHousetrained',  u'animalID',  u'animalIndoorOutdoor',  u'animalKillDate', u'animalKillReason',  u'animalLocation',  u'animalLocationState', u'animalMicrochipped', u'animalMixedBreed', u'animalName', u'animalNeedsFoster', u'animalNewPeople',   u'animalOKWithCats', u'animalOKWithDogs',  u'animalOKWithKids', u'animalOrgID', u'animalPictures', u'animalPrimaryBreed', u'animalRescueID', u'animalSearchString', u'animalSecondaryBreed', u'animalSex', u'animalSizeCurrent', u'animalSizePotential', u'animalSpecialneeds', u'animalSpecialneedsDescription', u'animalStatus', u'animalStatusID', u'animalSummary', u'animalUpdatedDate', u'animalUptodate', u'animalUrl', u'animalVideoUrls', u'animalVideos', u'fosterName', u'locationState', u'locationUrl']


thrown_fields= [u'animalAffectionate',u'animalCoatLength', u'animalColorID', u'animalCratetrained',u'animalDistinguishingMarks', u'animalDrools', u'animalEagerToPlease', u'animalEarType', u'animalEnergyLevel', u'animalEscapes', u'animalEventempered', u'animalExerciseNeeds', u'animalEyeColor', u'animalFence', u'animalFetches',u'animalGentle', u'animalGoodInCar', u'animalGoofy', u'animalGroomingNeeds', u'animalHasAllergies', u'animalHearingImpaired', u'animalHypoallergenic',u'animalIndependent',u'animalIntelligent',u'animalLap', u'animalLeashtrained', u'animalLocationDistance', u'animalNeedsCompanionAnimal', u'animalNoCold', u'animalNoFemaleDogs', u'animalNoHeat', u'animalNoLargeDogs', u'animalNoMaleDogs', u'animalNoSmallDogs', u'animalNotHousetrainedReason', u'animalOKForSeniors',u'animalOKWithAdults',u'animalOKWithFarmAnimals', u'animalObedienceTraining', u'animalObedient', u'animalOlderKidsOnly', u'animalOngoingMedical', u'animalPattern', u'animalPatternID',  u'animalPlayful', u'animalPlaysToys', u'animalPredatory', u'animalProtective', u'animalShedding', u'animalSightImpaired', u'animalSkittish', u'animalSpecialDiet', u'animalSponsorable', u'animalSponsors', u'animalSponsorshipDetails', u'animalSponsorshipMinimum',  u'animalSwims', u'animalTailType', u'animalTimid', u'animalVocal', u'animalYardRequired', u'fosterEmail', u'fosterFirstname', u'fosterLastname',u'fosterPhoneCell', u'fosterPhoneHome', u'fosterSalutation', u'locationCountry', u'locationPhone', u'locationPostalcode',u'locationAddress', u'locationCity', u'animalAgeString',u'animalApartment', u'animalBirthdateExact', u'animalCourtesy',u'animalFoundPostalcode',u'animalLocationCoordinates', u'animalLocationCitystate', u'animalOwnerExperience', u'animalPrimaryBreedID', u'animalSecondaryBreedID',u'animalSizeUOM', u'animalSpecies', u'animalSpeciesID',u'locationName', u'animalThumbnailUrl',]