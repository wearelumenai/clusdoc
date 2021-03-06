+++
title = "Getting Started"
description = "Quick introduction"
date = 2019-11-29T20:32:00+01:00
weight = 10
draft = false
bref = "Quick introduction"
toc = true
+++

[github]: /github-logo.png


# Introduction <img style="float: right;" src="/lakelady.jpg" width="300">


**The Lady of the Lake** is an enchantress in the Matter of Britain, the body of medieval literature and legend associated with King Arthur. She plays a pivotal role in many stories, including giving Arthur his sword Excalibur, enchanting Merlin, and raising Lancelot after the death of his father (Source [Wikipedia](https://en.wikipedia.org/wiki/Lady_of_the_Lake)). In what follows, **The lady of the lake** gives datascientists swords and tools to segment, cluster, visualize and analyze alive data.

> Wait, what ? Alive data ???

In LumenAI, we consider data, such as part of our environment, has their own live, above and beyond our understanding of the world. Instead of being outdated data-analyst by working only on static models, in addition, we want to be up-to-date data-partners, in asking dynamic and continuous questions, in order to improve our data-understanding, and so, during all data lifecycle.

In what follows, you are going to analyze in real-time, data flow with the possibility to modify your parameters without stopping the analysis. So, welcome to the magic of **The lady of the lake**.

# Open-source Tools

## [distclus](https://github.com/wearelumenai/distclus)

Golang open-source library providing our technology-core with online clustering loop control, aiming to transform all static clustering algorithms to online clustering algorithms, with all powerful of the online execution paradigm.

We propose hic et nunc three algorithms:

- the vanilla kmeans, where users have to fix k and can perform online clustering with a fixed number of clusters,
- a mcmc online learning algorithm, based on this paper: [A quasi-bayesian perspective to Online Clustering](https://projecteuclid.org/euclid.ejs/1537430425),
- a streaming algorithm,

as well as three different metrics or similarities:

- euclidean to analyze vectors of features in the standard Euclidean space,
- cosinus to analyze vectors of features with the cosine similarity,
- dtw to analyze multivariate time series with the state-of-the-art Dynamic Time Warping (DTW) similarity.

## [distclus4py](https://github.com/wearelumenai/distclus4py)

Python connector for distclus.

## [evclus](https://github.com/wearelumenai/evclus)

Python distclus4py server with automatic pre-processing based on business data model schema, and specific output gateway.

## [bubbles](https://github.com/wearelumenai/bubbles)

Web cluster visualisation tool with [d3js](https://d3js.org/).

## [bubbles4py](https://github.com/wearelumenai/bubbles4py)

Cluster visualisation tool based on **bubbles** and **distclus4py** for analyzing in a [ipython-notebook](https://jupyter.org/).

# Platform

We provide a more human-friendly solution for expert and common users aiming to analyze and visualize data model and clusters.

## Deployment

Clone the repository [lakelady](https://github.com/wearelumenai/lakelady).

```bash
git clone https://github.com/wearelumenai/lakelady
```

Then, read the [README](https://github.com/wearelumenai/lakelady/blob/master/README.md) for configuring your environment (dev, prod, distributed, etc.).

For example, taping

```bash
make
```

Will launch both platform and this documentation on your computer.

## Services

### [clusdoc](/docs/platform/clusdoc)

This documentation

### [clusfront](/docs/platform/clusfront)

User interface for analyzing and visualizing data model.

Our SaaS is available at https://lakelady.fr

### [cluserve](/docs/platform/cluserve)

Batch/Online clustering server with graphql API and a playground.

Our SaaS is available at https://cluserve.lakelady.fr/v1/graphql

### [clustore](/docs/platform/clustore)

Backend with a graphql API.

Our SaaS is available at https://clustore.lakelady.fr/v1/graphql

### [clusauth](/docs/platform/clusauth)

Authentication service.

Our SaaS is available at https://clusauth.lakelady.fr/login

### [grphclus](/docs/platform/grphclus)

Graph clustering service.

### [evclus](/docs/platform/evclus)

Event clustering.

Our clustering schema builder is available at https://cluschema.lakelady.fr

# What's next ?

Feel free to dive deep into the documentation to learn more about the architectural
design of The lady of the lake, or read the tutorials on how to use it.
