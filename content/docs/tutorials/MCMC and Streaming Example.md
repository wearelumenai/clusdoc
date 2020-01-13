+++
title = "MCMC and Streaming"
description = "Simple Batch Clustering"
date = 2019-12-19T12:32:00+01:00
weight = 10
draft = false
bref = "Simple Batch Clustering"
toc = true
+++

[github]: /github-logo.png

In this notebook, we propose a simple use of Streaming and MCMC algorithm in a batch mode (that is to say, for a static dataset) to perform clustering of a randomly generated set of two dimensional vectors.

# Data generation

We first generate a set of n=100 000 two-dimensional gaussian vectors with K centers.


```python
import numpy as np
import random
import time
import matplotlib.pyplot as plt


np.random.seed(137465318)

mean = [0, 0]
cov = [[1, 0], [0, 4]]

n = 100000

data = np.random.multivariate_normal(mean,cov,size=n)

moove = [7,1,14,23]
for i, d in enumerate(data):
    for k in range(len(moove)):
        data[i,0] += moove[k] if i%(k+1) else 0

random.shuffle(moove)

for i, d in enumerate(data):
    for k in range(len(moove)):
        data[i,1] += moove[k] if i%(k+1) else 0

np.random.shuffle(data)


```


```python
from distclus import Streaming, MCMC
```

# MCMC algorithm

We start with a Monte Carlo Markov Chain approach, based on the theoretical regret bounds stated in [this paper](https://projecteuclid.org/euclid.ejs/1537430425) in the online learning paradigm. Play with parameters amp (the temperature of the Gibbs measure) in order to add centers (the hotter it is, the more centers). You can also play with the number of centers to initialize the Markov chain, the maximum number of centers, and - of course - the number of iterations in the Markov Chain construction.


```python
%%time
%matplotlib inline

dim = data.shape[1]
algo = MCMC(init_k=1,amp=.05, mcmc_iter=50,seed=136363137)

algo.fit(data)

labels=algo.predict(data)

print(len(algo.centroids),'centroids after',int(algo.iterations),'iterations')


for l in np.unique(labels):
    plt.plot(data[labels==l,0], data[labels==l,1], 'o')
plt.plot(algo.centroids[:,0], algo.centroids[:,1], 'o', color='black')
print('compression rate',len(data)/len(algo.centroids))
```

    8 centroids after 50 iterations
    compression rate 12500.0
    CPU times: user 7.49 s, sys: 132 ms, total: 7.62 s
    Wall time: 586 ms



![png](MCMC%20and%20Streaming%20Example_files/MCMC%20and%20Streaming%20Example_7_1.png)



```python
%%time
dim = data.shape[1]

algo = MCMC(init_k=2,amp=1,max_k=1000, dim=dim, mcmc_iter=200,seed=136363137)

algo.fit(data)

print(len(algo.centroids),'centroids after',int(algo.iterations),'iterations')

labels=algo.predict(data)

%matplotlib inline

for l in np.unique(labels):
    plt.plot(data[labels==l,0], data[labels==l,1], 'o')
plt.plot(algo.centroids[:,0], algo.centroids[:,1], 'o', color='black')

print('compression rate',len(data)/len(algo.centroids))
```

    26 centroids after 200 iterations
    compression rate 3846.153846153846
    CPU times: user 44 s, sys: 940 ms, total: 44.9 s
    Wall time: 2.92 s



![png](MCMC%20and%20Streaming%20Example_files/MCMC%20and%20Streaming%20Example_8_1.png)


# Streaming algorithm

The streaming algorithm is naturally a sequential algorithm. We then first design a simple push and run function to initialialize and run the algorithm in an asynchronous mode. In this case, after the second, the algorithm will treat each data point sequentially.

**Warning: you need to initialize the algorithm first, by pushing at least one point before execution**.


```python
def push_and_run(algo, data, init=1):
    algo.push(data[:init]) # needed for initialization
    algo.run(rasync=True)
    algo.push(data[init:])
    algo.close()
```

We perform a streaming analysis below. Play with mu parameter in order to add centers (mu acts as a threshold to decide to add or reduce the number of centers). If you want to increase the randomness, play with sigma (0 gives a deterministic result).


```python
%%time 
dim = data.shape[1]
algo = Streaming(mu=0.4, sigma=0, outRatio=2, outAfter=7, seed=136363137)

push_and_run(algo, data)

labels=algo.predict(data)

print(len(algo.centroids),'centroids')
print("max distance", algo.max_distance)
#max distance is the max ratio between the distance of the new point and the nearest center divided by the past maximum
%matplotlib inline
import matplotlib.pyplot as plt

for l in np.unique(labels):
    plt.plot(data[labels==l,0], data[labels==l,1], 'o')
plt.plot(algo.centroids[:,0], algo.centroids[:,1], 'o', color='black')
print('compression rate',len(data)/len(algo.centroids))
```

    12 centroids
    max distance 28.69927595185876
    compression rate 8333.333333333334
    CPU times: user 412 ms, sys: 44 ms, total: 456 ms
    Wall time: 209 ms



![png](MCMC%20and%20Streaming%20Example_files/MCMC%20and%20Streaming%20Example_13_1.png)



```python
%%time
dim = data.shape[1]
algo = Streaming(mu=0.5, sigma=0.1, outRatio=2, outAfter=7, seed=136363137)
push_and_run(algo, data)

labels=algo.predict(data)

print(len(algo.centroids),'centroids')

for l in np.unique(labels):
    plt.plot(data[labels==l,0], data[labels==l,1], 'o')
plt.plot(algo.centroids[:,0], algo.centroids[:,1], 'o', color='black')
print('compression rate',len(data)/len(algo.centroids))
```

    9 centroids
    compression rate 11111.111111111111
    CPU times: user 488 ms, sys: 40 ms, total: 528 ms
    Wall time: 271 ms



![png](MCMC%20and%20Streaming%20Example_files/MCMC%20and%20Streaming%20Example_14_1.png)



```python
%%time
dim = data.shape[1]
algo = Streaming(mu=0.2, sigma=0.05, outRatio=2, outAfter=7, seed=136363137)
push_and_run(algo, data)

labels=algo.predict(data)

print(len(algo.centroids),'centroids')

%matplotlib inline
import matplotlib.pyplot as plt

for l in np.unique(labels):
    plt.plot(data[labels==l,0], data[labels==l,1], 'o')
plt.plot(algo.centroids[:,0], algo.centroids[:,1], 'o', color='black')
print('compression rate',len(data)/len(algo.centroids))
```

    186 centroids
    compression rate 537.6344086021505
    CPU times: user 1.67 s, sys: 64 ms, total: 1.74 s
    Wall time: 721 ms



![png](MCMC%20and%20Streaming%20Example_files/MCMC%20and%20Streaming%20Example_15_1.png)

