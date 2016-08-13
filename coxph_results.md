Final CoxPH results:

Call:
coxph(formula = survival ~ Pitbull + Microchipped + Desc_Latent_Topic.cut +
    Description_Length.cut + +GeneralAge + GeneralSizePotential +
    Specialneeds + Housetrained + GoodShelter + BadShelter +
    MixedBreed + Mostly_Black + Age_at_Start + OKWithCats + OKWithDogs +
    OKWithKids + Region + NumPictures.cut + NewPeople + NeedsFoster +
    ActivityLevel + AdoptionFee + Altered + IndoorOutdoor + BiggestVideos.cut +
    Uptodate + Search_String_Num_Terms.cut + SizeCurrent.cut,
    data = dogs)

  n= 152259, number of events= 148083

                                            coef  exp(coef)   se(coef)       z Pr(>|z|)
Pitbull                               -2.037e-01  8.157e-01  1.071e-02 -19.026  < 2e-16 ***
Microchipped1.0                        8.077e-01  2.243e+00  8.376e-03  96.437  < 2e-16 ***
MicrochippedUnknown                    2.138e-01  1.238e+00  6.671e-03  32.052  < 2e-16 ***
Desc_Latent_Topic.cut(0,1]            -2.178e-01  8.043e-01  1.476e-02 -14.755  < 2e-16 ***
Desc_Latent_Topic.cut(1,2]            -2.272e-01  7.968e-01  9.629e-03 -23.597  < 2e-16 ***
Desc_Latent_Topic.cut(2,3]            -2.301e-01  7.944e-01  5.816e-03 -39.565  < 2e-16 ***
Description_Length.cut(500,1e+03]      1.622e-03  1.002e+00  6.477e-03   0.250  0.80232
Description_Length.cut(1e+03,1.5e+03]  1.718e-02  1.017e+00  8.223e-03   2.089  0.03667 *
Description_Length.cut(1.5e+03,2e+04] -7.357e-02  9.291e-01  8.871e-03  -8.293  < 2e-16 ***
GeneralAgeBaby                         3.529e-01  1.423e+00  1.008e-02  35.001  < 2e-16 ***
GeneralAgeSenior                      -1.422e-01  8.674e-01  1.888e-02  -7.534 4.91e-14 ***
GeneralAgeUnknown                     -1.893e-01  8.275e-01  1.179e-02 -16.053  < 2e-16 ***
GeneralAgeYoung                        1.004e-01  1.106e+00  8.314e-03  12.081  < 2e-16 ***
GeneralSizePotentialMedium            -7.291e-03  9.927e-01  7.517e-03  -0.970  0.33206
GeneralSizePotentialSmall              5.196e-02  1.053e+00  8.375e-03   6.204 5.50e-10 ***
GeneralSizePotentialUnknown            2.833e-01  1.328e+00  1.020e-02  27.788  < 2e-16 ***
GeneralSizePotentialX-Large            9.692e-02  1.102e+00  1.982e-02   4.889 1.01e-06 ***
Specialneeds                          -2.249e-01  7.986e-01  1.710e-02 -13.151  < 2e-16 ***
Housetrained1.0                       -7.278e-03  9.927e-01  9.644e-03  -0.755  0.45045
HousetrainedUnknown                    8.099e-02  1.084e+00  8.948e-03   9.051  < 2e-16 ***
GoodShelter                            4.455e-01  1.561e+00  1.169e-02  38.125  < 2e-16 ***
BadShelter                            -8.500e-01  4.274e-01  2.308e-02 -36.828  < 2e-16 ***
MixedBreed                            -2.289e-01  7.954e-01  1.127e-02 -20.313  < 2e-16 ***
Mostly_Black                          -4.491e-02  9.561e-01  6.261e-03  -7.173 7.33e-13 ***
Age_at_Start                           1.420e-02  1.014e+00  1.945e-03   7.302 2.83e-13 ***
OKWithCats1.0                          1.429e-01  1.154e+00  1.342e-02  10.647  < 2e-16 ***
OKWithCatsUnknown                      1.858e-01  1.204e+00  1.316e-02  14.113  < 2e-16 ***
OKWithDogs1.0                          2.742e-01  1.315e+00  2.800e-02   9.794  < 2e-16 ***
OKWithDogsUnknown                      2.919e-01  1.339e+00  2.879e-02  10.139  < 2e-16 ***
OKWithKids1.0                          2.332e-01  1.263e+00  1.848e-02  12.622  < 2e-16 ***
OKWithKidsUnknown                      2.757e-01  1.317e+00  1.877e-02  14.689  < 2e-16 ***
RegionMidwest                         -1.380e-01  8.711e-01  3.276e-02  -4.213 2.52e-05 ***
RegionNortheast                        3.330e-02  1.034e+00  3.310e-02   1.006  0.31450
RegionSouth                           -3.693e-01  6.912e-01  3.241e-02 -11.395  < 2e-16 ***
RegionTerritory                       -5.032e-01  6.046e-01  2.261e-01  -2.225  0.02605 *
RegionWest                            -2.266e-01  7.972e-01  3.264e-02  -6.943 3.83e-12 ***
NumPictures.cut(0,2]                  -9.798e-02  9.067e-01  2.076e-02  -4.721 2.35e-06 ***
NumPictures.cut(2,4]                  -6.806e-03  9.932e-01  2.070e-02  -0.329  0.74232
NumPictures.cut(4,100]                 1.923e-01  1.212e+00  2.150e-02   8.941  < 2e-16 ***
NewPeopleCautious                      2.466e-01  1.280e+00  2.050e-01   1.203  0.22886
NewPeopleFriendly                      3.325e-01  1.394e+00  2.046e-01   1.625  0.10419
NewPeopleProtective                    2.334e-01  1.263e+00  2.170e-01   1.075  0.28227
NewPeopleUnknown                       4.467e-01  1.563e+00  2.046e-01   2.183  0.02900 *
NeedsFoster                            1.378e-01  1.148e+00  1.113e-02  12.387  < 2e-16 ***
ActivityLevelModerately Active        -5.238e-02  9.490e-01  9.149e-03  -5.725 1.03e-08 ***
ActivityLevelNot Active               -1.105e-01  8.954e-01  4.350e-02  -2.541  0.01106 *
ActivityLevelSlightly Active          -4.520e-02  9.558e-01  1.542e-02  -2.931  0.00338 **
ActivityLevelUnknown                  -1.843e-01  8.317e-01  1.100e-02 -16.758  < 2e-16 ***
AdoptionFee                            5.232e-04  1.001e+00  2.503e-05  20.909  < 2e-16 ***
Altered                               -1.355e-01  8.733e-01  1.058e-02 -12.806  < 2e-16 ***
IndoorOutdoorIndoor Only               1.985e-01  1.220e+00  8.240e-03  24.097  < 2e-16 ***
IndoorOutdoorOutdoor Only              4.553e-02  1.047e+00  8.801e-02   0.517  0.60494
IndoorOutdoorUnknown                  -7.914e-03  9.921e-01  8.899e-03  -0.889  0.37380
BiggestVideos.cut                      4.715e-01  1.602e+00  7.199e-03  65.491  < 2e-16 ***
Uptodate                               2.301e-01  1.259e+00  2.636e-02   8.731  < 2e-16 ***
Search_String_Num_Terms.cut(5,10]     -1.924e-01  8.250e-01  3.198e-02  -6.015 1.80e-09 ***
Search_String_Num_Terms.cut(10,15]    -2.130e-01  8.081e-01  3.188e-02  -6.682 2.36e-11 ***
Search_String_Num_Terms.cut(15,100]   -2.469e-01  7.812e-01  3.215e-02  -7.678 1.61e-14 ***
SizeCurrent.cut(10,25]                 1.289e-01  1.138e+00  6.763e-03  19.066  < 2e-16 ***
SizeCurrent.cut(25,1e+04]              1.031e-01  1.109e+00  8.120e-03  12.691  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

                                      exp(coef) exp(-coef) lower .95 upper .95
Pitbull                                  0.8157     1.2259    0.7988    0.8330
Microchipped1.0                          2.2428     0.4459    2.2063    2.2799
MicrochippedUnknown                      1.2384     0.8075    1.2223    1.2547
Desc_Latent_Topic.cut(0,1]               0.8043     1.2433    0.7814    0.8279
Desc_Latent_Topic.cut(1,2]               0.7968     1.2551    0.7819    0.8119
Desc_Latent_Topic.cut(2,3]               0.7944     1.2588    0.7854    0.8035
Description_Length.cut(500,1e+03]        1.0016     0.9984    0.9890    1.0144
Description_Length.cut(1e+03,1.5e+03]    1.0173     0.9830    1.0011    1.0339
Description_Length.cut(1.5e+03,2e+04]    0.9291     1.0763    0.9131    0.9454
GeneralAgeBaby                           1.4231     0.7027    1.3953    1.4515
GeneralAgeSenior                         0.8674     1.1528    0.8359    0.9001
GeneralAgeUnknown                        0.8275     1.2084    0.8086    0.8469
GeneralAgeYoung                          1.1057     0.9044    1.0878    1.1238
GeneralSizePotentialMedium               0.9927     1.0073    0.9782    1.0075
GeneralSizePotentialSmall                1.0533     0.9494    1.0362    1.0708
GeneralSizePotentialUnknown              1.3276     0.7533    1.3013    1.3544
GeneralSizePotentialX-Large              1.1018     0.9076    1.0598    1.1454
Specialneeds                             0.7986     1.2522    0.7723    0.8258
Housetrained1.0                          0.9927     1.0073    0.9742    1.0117
HousetrainedUnknown                      1.0844     0.9222    1.0655    1.1035
GoodShelter                              1.5613     0.6405    1.5260    1.5975
BadShelter                               0.4274     2.3396    0.4085    0.4472
MixedBreed                               0.7954     1.2572    0.7781    0.8132
Mostly_Black                             0.9561     1.0459    0.9444    0.9679
Age_at_Start                             1.0143     0.9859    1.0104    1.0182
OKWithCats1.0                            1.1536     0.8668    1.1237    1.1844
OKWithCatsUnknown                        1.2042     0.8305    1.1735    1.2356
OKWithDogs1.0                            1.3155     0.7602    1.2452    1.3897
OKWithDogsUnknown                        1.3390     0.7468    1.2655    1.4167
OKWithKids1.0                            1.2627     0.7920    1.2177    1.3092
OKWithKidsUnknown                        1.3174     0.7591    1.2699    1.3668
RegionMidwest                            0.8711     1.1480    0.8169    0.9288
RegionNortheast                          1.0339     0.9673    0.9689    1.1032
RegionSouth                              0.6912     1.4467    0.6487    0.7366
RegionTerritory                          0.6046     1.6540    0.3881    0.9417
RegionWest                               0.7972     1.2544    0.7478    0.8499
NumPictures.cut(0,2]                     0.9067     1.1029    0.8705    0.9443
NumPictures.cut(2,4]                     0.9932     1.0068    0.9537    1.0343
NumPictures.cut(4,100]                   1.2120     0.8251    1.1620    1.2641
NewPeopleCautious                        1.2797     0.7814    0.8563    1.9124
NewPeopleFriendly                        1.3944     0.7172    0.9337    2.0823
NewPeopleProtective                      1.2628     0.7919    0.8253    1.9323
NewPeopleUnknown                         1.5632     0.6397    1.0468    2.3344
NeedsFoster                              1.1478     0.8712    1.1230    1.1731
ActivityLevelModerately Active           0.9490     1.0538    0.9321    0.9661
ActivityLevelNot Active                  0.8954     1.1169    0.8222    0.9750
ActivityLevelSlightly Active             0.9558     1.0462    0.9273    0.9851
ActivityLevelUnknown                     0.8317     1.2024    0.8140    0.8498
AdoptionFee                              1.0005     0.9995    1.0005    1.0006
Altered                                  0.8733     1.1451    0.8553    0.8916
IndoorOutdoorIndoor Only                 1.2196     0.8199    1.2001    1.2395
IndoorOutdoorOutdoor Only                1.0466     0.9555    0.8808    1.2436
IndoorOutdoorUnknown                     0.9921     1.0079    0.9750    1.0096
BiggestVideos.cut                        1.6023     0.6241    1.5799    1.6251
Uptodate                                 1.2588     0.7944    1.1954    1.3255
Search_String_Num_Terms.cut(5,10]        0.8250     1.2121    0.7749    0.8784
Search_String_Num_Terms.cut(10,15]       0.8081     1.2374    0.7592    0.8602
Search_String_Num_Terms.cut(15,100]      0.7812     1.2800    0.7335    0.8321
SizeCurrent.cut(10,25]                   1.1376     0.8790    1.1226    1.1528
SizeCurrent.cut(25,1e+04]                1.1086     0.9021    1.0910    1.1263

Concordance= 0.644  (se = 0.001 )
Rsquare= 0.234   (max possible= 1 )
Likelihood ratio test= 40648  on 60 df,   p=0
Wald test            = 40255  on 60 df,   p=0
Score (logrank) test = 41753  on 60 df,   p=0

> extractAIC(results)
[1]      60 3196747
