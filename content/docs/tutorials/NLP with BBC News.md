
# NLP with BBC news articles 

In this notebook, we use distclus4py and bubbles4py to perform batch and online analysis of a dataset of 2225 BBC news articles from http://mlg.ucd.ie/datasets/bbc.html with 5 topics (business, entertainment, politics, sport, tech) and build a javascript visualization of the results.

We stack several steps as follows:

1. Batch training of x% of the sample:
    - construction of a word embedding with fasttext thanks to the articles bodies,
    - clustering based on a batch analysis with one given algorithm (streaming, mcmc, or kmeans from distclus4py package).
2. Vizualization of the result thanks to bubbles4py

3. On the fly clustering of a test set:
    - real time embedding thanks to the fasttext embedding trained in 1.,
    - online clustering with initialisation based on 1.
3. Vizualization of the resulting clusters to compare with 2.

## Data extraction


```python
from os import listdir

folders = ['business','entertainment','politics','sport','tech']

dataset = []#list of 2-uplet (article body,class)
for topic in folders:
    file_list = [f for f in listdir('data/bbc/'+topic) if f[0]!='.']
    #print(file_list)
    for filename in file_list:
        with open('data/bbc/'+topic+'/'+filename) as f:
            #print(topic,filename)
            contain = f.readlines()
            result = ''
            for elt in contain:
                if elt != '\n':
                    result+= elt[:-1]+' '
        dataset.append((result,topic))
#print(dataset[0])
```


```python
import numpy as np, psutil
import datetime
import time
import fasttext
import json, collections
import string
import matplotlib.pyplot as plt
```

# Part I :Batch training (embedding + clustering)

In this part, we train a fasttext word embedding and a clustering of the given output vectors with the first x% of the dataset. The objective is to save these models (embedding + centroids) in order to use it for on the fly clustering in Part II.

## Training of the word embedding

We extract bodies and classes and train x% of the first articles.




```python
import random

x = 50#pourcentage for trainset

random.shuffle(dataset)

n = len(dataset)
n_train = int(x*n/100)
trainset = dataset[:n_train]
testset = dataset[n_train:]
n_test = len(testset)
print(len(trainset),'articles in the train over',n,'articles')#1769959

```

    1112 articles in the train over 2224 articles


We construct a csv file containing all the bodies of the train set, with option to lemmatize the corpus (al=vailable soon).


```python
stop = n_train
cpt=0

outfile = 'corpus_bbc'+str(x)+'%'+'.csv'
f = open(outfile,'w')

for article in trainset:
    line = article[0]
    f.write(line+'\n')
    cpt+=1
print(outfile,'created with',cpt,'lines')
f.close()
```

    corpus_bbc50%.csv created with 1112 lines


## Train the embedding using FastText

We open the csv corpus file containing one body by line in UTF-8 format and train a FastText Cbow model. It takes 2 seconds for 1112 lines (50% of the entire dataset) in our 32-CPU servor.


```python
%%time

corpusfile = outfile
#checking encoding UTF-8
#with open(corpusfile as f:
#    print(f)


# Skipgram model :
#model = fasttext.train_unsupervised(corpusfile, model='skipgram')

# or, cbow model :

d = 30
model = fasttext.train_unsupervised(corpusfile, model='cbow',dim=d)
model.save_model("model_"+corpusfile+".bin")
```

    CPU times: user 21.9 s, sys: 336 ms, total: 22.2 s
    Wall time: 2.13 s


## Clustering of the train set

Here we vectorize each body of the train set in order to give to our clustering algorithm.


```python
#generic function used for train AND on the fly test
#input : a body
#output : a vector (sum of vectors of each word of the body)
def vectorize(body):
    list_words =body.split()
    vect = np.zeros((1,d))
    for w in list_words:
        vect += model[w]
    return(vect)

with open(corpusfile) as f:
    list_vectors = [vectorize(line) for line in f]        # create a list of vectors representing bodies

train_vectors = np.array(list_vectors).reshape(n_train,-1)
```

We are ready to give this train vectors to our distclus library. We push these vectors in one batch and check the response of our Stremaing and MCMC algorithm. 

WARNING: algo is running asynchronously and is still open after this block. It will be used again for on the fly analysis in Section 2. 

## Streaming clustering

Here we first give vectors of the trainset to our streaming algorithm. Articles are analyzed one by one. We ask for the number of clusters every 10 miliseconds.


```python
from distclus import Streaming

#Streaming
algo = Streaming(mu=0.45, sigma=0.1, outRatio=2, outAfter=7)
print('Analyzing',n_train,'articles---')
algo.push(train_vectors[:1])
algo.run(rasync=True)
algo.push(train_vectors[1:])
for k in range(10):#monitoring during 10 seconds
    print(len(algo.centroids),'centers',end='|')
    time.sleep(0.01)
```

    Analyzing 1112 articles---
    24 centers|24 centers|24 centers|24 centers|24 centers|24 centers|24 centers|24 centers|24 centers|24 centers|

## MCMC algorithm (using Batch decorator)

We also test our MCMC algorithm in a Batch mode. Batch object allows to perform a batch clustering using MCMC algorithm. You can play with parameters amp (the amplitude contsant in front of the temperature of the Gibbs measure) in order to add centers (the hotter it is, the more centers). You can also play with the number of centers to initialize the Markov chain, the maximum number of centers, and - of course - the number of iterations (all the vectors of the training set are used at each iterationin the batch mode).


```python
from distclus import Batch, MCMC

print('Analyzing',n_train,'articles---')
algo = Batch(MCMC, init_k=5, b=1.,frame_size=n,amp=5,max_k = 10,mcmc_iter=5)
algo.run()
algo.push(train_vectors)
print(len(algo.centroids),'centers')
```

    Analyzing 1112 articles---
    6 centers


# Vizualization of the clustering of the train set

We start a first analysis of the result. These few lines of code allow to generate a javascript visualisation of each cluster in your browser with bubbles and axes.
We first ask the label of each trained vectors.


```python
labels=algo.predict(train_vectors)
```

We then count the size of each cluster.


```python
def counts(centroids,labels):
    results = []
    for k in range(len(centroids)):
        cluster_i = np.where(labels==k)
        results.append(len(cluster_i[0]))
    return(results)

print(counts(algo.centroids,labels))
    
```

    [52, 156, 33, 208, 77, 196, 80, 34, 15, 17, 4, 48, 20, 7, 5, 27, 1, 43, 63, 19, 2, 2, 2, 1]


We construct a matrix to describe each cluster thanks to the topic (entertainment, politics, business, etc).


```python
K = len(algo.centroids)
L = len(folders)
matrix_scores = np.zeros((K,L))

for i in range(K):
    current_topics = [x[1] for k,x in enumerate(trainset) if labels[k]==i]
    for j,topic in enumerate(folders):
        matrix_scores[i,j] = len([elt for elt in current_topics if elt==topic])/len([e for e in labels if e==i])
```

The following block generate an URL with the desired visualisation.


```python

from bubbles.drivers import MemDriver
from bubbles import Server
from random import randint
import requests


centers = matrix_scores.tolist()

result = {'centers': centers, 'counts': counts(algo.centroids,labels), 'columns': folders}

driver = MemDriver()
server = Server(driver)
port = randint(44001, 44999)
server.start(timeout=10, host='luzine.lumenai.fr', port=port, quiet=True)

result_id = driver.put_result(result)
print('http://luzine.lumenai.fr:{}/bubbles?result_id={}'.format(port, result_id))
```

    http://luzine.lumenai.fr:44768/bubbles?result_id=arznlpfzhgdazlrpzzdrngugeraumbop


# On the fly analysis of a test dataset

We are ready to analyze the test set sequentially in order to check the evolution of the dataset. We first select the size of the test set to give to the algorithm.


```python
print('We start a real time clustering of',len(testset),'articles')
```

    We start a real time clustering of 1112 articles


    WARNING:root:timeout reached, server was terminated


We then give one by one each article of the test set, proceed to the embedding thanks to the FastText model, and monitore the response of the online clustering algorithm after 100 milliseconds.


```python
%%time
print('####')
print(len(algo.centroids),'centers at the beginning of the test xp')

test_vectors = []
new_date = []#list pf date with new center
past_K = len(algo.centroids)#number of centers at the present time
all_vectors = train_vectors

for i, elt in enumerate(testset):
    body = elt[0]
    new_vector = vectorize(body)
    all_vectors = np.append(all_vectors,new_vector,axis=0)
    current_label = algo.predict(new_vector)
    algo.push(new_vector)
    test_vectors.append(new_vector)
    time.sleep(0.03)
    labels = algo.predict(all_vectors)
    if len(algo.centroids)<past_K:
        print('kill cluster for data',i,'with label',int(current_label))
    if len(algo.centroids)>past_K:
        print('new center for data',i,'with label',int(current_label))
    else:
        pass
    past_K = len(algo.centroids)
print(len(algo.centroids),'centers at the end of the test xp')
```

    ####
    24 centers at the beginning of the test xp
    24 centers at the end of the test xp
    CPU times: user 17.5 s, sys: 948 ms, total: 18.4 s
    Wall time: 43.8 s


# Visualization after the test experience

Here we propose to vizualize the resulting clustering (train +test analysis), where the size of the clusters are associated with the number of test data.


```python
labels = algo.predict(all_vectors)


K = len(algo.centroids)

matrix_scores = np.zeros((K,5))

for i in range(K):
    if len([x for x in labels if x==i])>0:
        current_topics = [x[1] for k,x in enumerate(dataset) if labels[k]==i]
        for j,topic in enumerate(folders):
            matrix_scores[i,j] = len([elt for elt in current_topics if elt==topic])/len([x for x in labels if x==i])
    else:
        matrix_scores[i,:] = np.zeros((1,5))

centers = matrix_scores.tolist()


result = {'centers': centers, 'counts': counts(algo.centroids,labels), 'columns': folders}

driver = MemDriver()
server = Server(driver)
port = randint(44001, 44999)
server.start(timeout=10, host='luzine.lumenai.fr', port=port, quiet=True)

result_id = driver.put_result(result)
print('http://luzine.lumenai.fr:{}/bubbles?result_id={}'.format(port, result_id))
```

    http://luzine.lumenai.fr:44620/bubbles?result_id=dkiuqwgxhgwouivzngeitbkgvknmrgku


    WARNING:root:timeout reached, server was terminated

