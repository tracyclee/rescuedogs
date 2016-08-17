import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.decomposition import TruncatedSVD, NMF

def describe_nmf_results(document_term_mat, W, H, n_top_words = 15):
    # print("Reconstruction error: %f") %(reconst_mse(document_term_mat, W, H))
    for topic_num, topic in enumerate(H):
        print("Topic %d:" % topic_num)
        print(" ".join([feature_words[i] \
                for i in topic.argsort()[:-n_top_words - 1:-1]]))
    return


if __name__ == '__main__':

    df=pd.read_csv('/Users/tracylee/raw_dogs/clean_data_no_dummies.csv')
    df['animalDescriptionPlain'].fillna('', inplace=True)
    descriptions = df['animalDescriptionPlain'].values
    n_features = 5000
    vectorizer = TfidfVectorizer(max_features=n_features, stop_words='english')
    document_term_mat = vectorizer.fit_transform(descriptions)
    feature_words = vectorizer.get_feature_names()

    n_topics = 4
    nmf = NMF(n_components=n_topics)
    W = nmf.fit_transform(document_term_mat)
    H = nmf.components_
    describe_nmf_results(document_term_mat, W, H)
    labels = np.argmax(W, axis=1)
    df['desc_latent_topic'] = labels

    '''
    Topic 0:
    nbsp adoption submit fee application foster animals pet amp age homes puppies information dogs prevention
    Topic 1:
    breed 39 microchips dog dogs predominant identification tags collar adopted know day microchip mix rescue
    Topic 2:
    adoption insurance pet 1st 4p4l 7pm event 4pm org events friday www days approximate fees
    Topic 3:
    home love loves dog little dogs family foster great sweet play good just 39 girl
    '''
