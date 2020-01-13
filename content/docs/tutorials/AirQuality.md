+++
title = "Batch analysis for Air Quality with Plumelabs"
description = "Batch analysis of Air Quality"
date = 2019-12-19T12:32:00+01:00
weight = 10
draft = false
bref = "Batch analysis of Air Quality"
toc = true
+++
 

In this notebook, we analyze a dataset coming from https://plumelabs.com/fr/ and a Flow which provides real time collect of NO2 (ppb), VOC (ppb), pm 10 (ug/m3) and pm 2.5 (ug/m3).

# Preprocess and cleaning

Files are available using the mobile app and sent by email in a zip format containing complete history of your Flow, namely:

1. air quality measurements in Plume AQI, ppb and ug/m3, in CSV format,
2. GPS measurements associated with latitude / longitude data, in CSV format,
3. Geographic data in KML format (Google Earth),
4. and associated images in PNG format.

In what follows, we only analyze 1. 


```python
import numpy as np
import pandas as pd
```


```python
#contain = pd.read_csv('data/user_measures_20190217_20191212_2.csv')
contain = pd.read_csv('data/user_measures_20180910_20190217_1.csv')
```


```python
print(np.sum(contain.isnull()))
print(contain.iloc[200:205,:5])
```

    timestamp               0
    date (UTC)              0
    NO2 (ppb)               0
    VOC (ppb)               0
    pm 10 (ug/m3)         253
    pm 2.5 (ug/m3)        286
    NO2 (Plume AQI)         0
    VOC (Plume AQI)         0
    pm 10 (Plume AQI)       0
    pm 2.5 (Plume AQI)      0
    dtype: int64
          timestamp           date (UTC)  NO2 (ppb)  VOC (ppb)  pm 10 (ug/m3)
    200  1536602377  2018-09-10 17:59:37        679          8           20.0
    201  1536602437  2018-09-10 18:00:37        676          8            1.0
    202  1536602497  2018-09-10 18:01:37        677          4           19.0
    203  1536602557  2018-09-10 18:02:37        679          3           16.0
    204  1536602617  2018-09-10 18:03:37        683         51           11.0


Plumelabs extraction have NaN values :\ We fill the NaN with zero thanks to pandas and extract only air quality measures in ppb and ug/m3 as follows:


```python
data = contain.iloc[:,[0,2,3,4,5]].fillna(method='pad')
np.sum(data.isnull())

```




    timestamp         0
    NO2 (ppb)         0
    VOC (ppb)         0
    pm 10 (ug/m3)     0
    pm 2.5 (ug/m3)    0
    dtype: int64




```python
data.to_csv('data/plumelabs_clean.csv',index=False,sep=",")
```

# Batch analysis

We then give these data to our clustering algorithm: MCMC and Streaming, and analyze it in a batch mode (sklearn friendly). 


```python
data = contain.iloc[:,[2,3,4,5]].fillna(method='pad')
print('Analyzing',list(data.columns))
dataset = np.array(data)
print('Numpy array of size',dataset.shape,'ready for distclus4py package')
#use it if you want to normalize
#WARNING : you will need to normalize in On the fly learning also (!)
def normalize(chunk):
    chunk = chunk - chunk.mean(axis=0)
    for k,elt in enumerate(chunk.T):
        if np.std(elt)!=0:
            chunk[:,k] = elt/np.std(elt)
    return(chunk)

dataset_n = normalize(dataset)
```

    Analyzing ['NO2 (ppb)', 'VOC (ppb)', 'pm 10 (ug/m3)', 'pm 2.5 (ug/m3)']
    Numpy array of size (48191, 4) ready for distclus4py package


## Streaming algorithm

We start with a streaming analysis. Play with mu parameter in order to add centers (mu acts as a threshold to decide to add a center, then the bigger mu, the smaller n is, 
the smaller x is, the more centers there will be). If you want to increase the randomness, play with sigma (0 gives a deterministic result):


```python
%%time
import time
from distclus import Streaming

dataset = np.array(dataset)
n = dataset.shape[0]

mu = 0.8#threshold parameter

print('Analyzing',n,'flow measures with mu=',mu,'------------')
#Streaming algorithm
algo = Streaming(mu=mu, sigma=0.1, outRatio=2, outAfter=7)
algo.push(dataset[:1])
algo.run(rasync=True)
algo.push(dataset[1:])
for k in range(10):#monitoring during 1 seconds since algo is running in a asynchronous mode
    print(len(algo.centroids),'centers',end='|')
    time.sleep(0.1)

#print(algo.centroids[0])
```

    Analyzing 48191 flow measures with mu= 0.8 ------------
    63 centers|63 centers|63 centers|63 centers|63 centers|63 centers|63 centers|63 centers|63 centers|63 centers|CPU times: user 420 ms, sys: 40 ms, total: 460 ms
    Wall time: 1.22 s


We also use the streaming algorithm in a loop form in order to get the labels of the data sequentially. 


```python
%%time

#True streaming
import time
from distclus import Streaming

dataset = np.array(dataset)
n = dataset.shape[0]

mu = 0.8#threshold parameter

print('Analyzing',n,'flow measures with mu=',mu,'------------')
#Streaming algorithm
algo = Streaming(mu=mu, sigma=0.1, outRatio=2, outAfter=7)
algo.push(dataset[:1])
algo.run(rasync=True)
labels = [algo.predict(dataset[:1])]
for elt in dataset[1:]:
    #print(elt)
    #print(algo.predict(elt.reshape(1,-1)))
    labels.append(algo.predict(elt.reshape(1,-1)))
    algo.push(elt.reshape(1,-1))

print(algo.centroids[0])
```

    Analyzing 48191 flow measures with mu= 0.8 ------------
    [0.01680672 0.01465546 0.00961345 0.01163025]
    CPU times: user 8.87 s, sys: 2.09 s, total: 11 s
    Wall time: 6.21 s


## MCMC algorithm

We then give the data to our MCMC algorithm. Batch object allows to perform a batch clustering using MCMC algorithm. Play with parameters amp (the temperature of the Gibbs measure) in order to add centers (the hotter it is, the more centers). You can also play with the number of centers to initialize the Markov chain, the maximum number of centers, and - of course - the number of iterations. 


```python
%%time

import time
from distclus import Batch

dataset = np.array(dataset)
n = dataset.shape[0]
print('Analyzing',n,'flow measures----')
algo = Batch(MCMC, init_k=80, frame_size=n, b=1., amp=5,max_k = 400,mcmc_iter=100)
algo.run()
algo.push(dataset)
print(len(algo.centroids),'centers',end='|')
```

    Analyzing 48191 flow measures----
    78 centers|CPU times: user 49.9 s, sys: 408 ms, total: 50.3 s
    Wall time: 2.3 s


## Viz with bubbles4py

We want a easy way to analyze our centroids and interacts with different axes of air quality measurements such NO2, OVC, etc. bubbles4py allows to open a new tab in your browser in order to plot and analyze clusters.


```python
#Function to give the size of each non-empty cluster to the viz
def count(labels,centroids):
    counts = []
    cpt = 0#number of empty clusters
    K = len(centroids)
    for k in range(K):
        cluster_i = np.where(labels==k)
        if len(cluster_i[0])>0:
            counts.append(len(cluster_i[0]))
        else:
            counts.append(0)
            cpt+=1
    print('Warning:',cpt,'empty clusters')
    return(counts)

```


```python
#bloc to generate the url of the d3.js vizualization

from bubbles.drivers import MemDriver
from bubbles import Server
from random import randint
import requests


#labels = algo.predict(dataset)#gives the label of each point of the dataset
counts = count(labels,algo.centroids)

centers = [x for k,x in enumerate(algo.centroids.tolist()) if counts[k]>0]#transform centroids numpy array into list of lists

counts = [x for x in counts if x>0]
result = {'centers': centers, 'counts': counts, 'columns': list(data.columns)}

driver = MemDriver()
server = Server(driver)
port = randint(44001, 44999)
server.start(timeout=10, host='luzine.lumenai.fr', port=port, quiet=True)

result_id = driver.put_result(result)
print('http://luzine.lumenai.fr:{}/bubbles?result_id={}'.format(port, result_id))
```

    Warning: 61 empty clusters
    http://luzine.lumenai.fr:44425/bubbles?result_id=bveonfhodjlhfppszueeyxlnxlnofpoa


    WARNING:root:timeout reached, server was terminated

