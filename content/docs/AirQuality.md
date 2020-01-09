+++
title = "Air Quality with Plumelabs"
description = "Batch analysis of Air Quality"
date = 2019-12-19T12:32:00+01:00
weight = 10
draft = false
bref = "Batch analysis of Air Quality"
toc = true
+++

[github]: /github-logo.png



[Plumelabs]( https://plumelabs.com/fr/) is a french startup developing a flow to analyze air quality in your everyday environment. This flow provides real time collect of NO2 (ppb), VOC (ppb), pm 10 (ug/m3) and pm 2.5 (ug/m3). It looks like this:

![Flow2](/flow.jpg)

## Preprocess and cleaning

Files are available using the mobile app and sent by email in a zip format containing complete history of your flow, namely:

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
contain = pd.read_csv('data/user_measures_20190217_20191212_2.csv')
#contain = pd.read_csv('data/user_measures_20180910_20190217_1.csv')
```


```python
print(np.sum(contain.isnull()))
print(contain.iloc[200:205,:5])
```

    timestamp                 0
    date (UTC)                0
    NO2 (ppb)                 0
    VOC (ppb)                 0
    pm 10 (ug/m3)             0
    pm 2.5 (ug/m3)          339
    NO2 (Plume AQI)           0
    VOC (Plume AQI)           0
    pm 10 (Plume AQI)         0
    pm 2.5 (Plume AQI)        0
    pm 1 (ug/m3)              0
    pm 1 (Plume AQI)      38320
    dtype: int64
          timestamp           date (UTC)  NO2 (ppb)  VOC (ppb)  pm 10 (ug/m3)
    200  1550413401  2019-02-17 14:23:21          0        174      82.810530
    201  1550413461  2019-02-17 14:24:21          0        177      36.271523
    202  1550413521  2019-02-17 14:25:21          0        181      55.954240
    203  1550413581  2019-02-17 14:26:21          0        184      26.449211
    204  1550413641  2019-02-17 14:27:21          0        190      19.275837


Unfortunately, my Plumelabs extraction have NaN values :\ We fill the NaN with zero thanks to pandas and extract only air quality measures in ppb and ug/m3 as follows:


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

## Batch analysis

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

We also give the data to our MCMC algorithm. Batch object allows to perform a batch clustering using MCMC algorithm. Play with parameters amp (the temperature of the Gibbs measure) in order to add centers (the hotter it is, the more centers). You can also play with the number of centers to initialize the Markov chain, the maximum number of centers, and - of course - the number of iterations. 


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


