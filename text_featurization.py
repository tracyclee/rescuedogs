import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.decomposition import TruncatedSVD, NMF


def reconst_mse(target, left, right):
    return (np.array(target - left.dot(right))**2).mean()

def describe_nmf_results(document_term_mat, W, H, n_top_words = 15):
    print("Reconstruction error: %f") %(reconst_mse(document_term_mat, W, H))
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
    n_topics = 7
    vectorizer = TfidfVectorizer(max_features=n_features, stop_words='english')
    document_term_mat = vectorizer.fit_transform(descriptions)
    feature_words = vectorizer.get_feature_names()

    nmf = NMF(n_components=n_topics)
    W_sklearn = nmf.fit_transform(document_term_mat)
    H_sklearn = nmf.components_
    describe_nmf_results(document_term_mat, W_sklearn, H_sklearn)
