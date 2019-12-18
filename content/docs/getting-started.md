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

# Introduction

**The lady of the lake** are machine learning tools dedicated to visualize and analyze alive data.

> Wait, what ? Alive data ???

In LumenAI, we consider data, such as part of our environment, has their own live, above and beyond our understanding of the world.

Instead of being outdated data-analyst by working only on static models, in addition, we want to be up-to-date data-partners, in asking dynamic and continuous questions, in order to improve our data-understanding, and so, during all data lifecycle.

Therefore, in using **The lady of the lake**, you are going to analyze in real-time, data flow with the possibility to modify your parameters without stopping the analysis.

# Open-source Tools

## [distclus](https://github.com/wearelumenai/distclus)

Golang open-source library providing our technology-core with online clustering loop control, aiming to transform all static algorithms to online clustering algorithms, with all powerful of the online execution paradigm.

We give an example of three algorithms:
- kmeans
- mcmc
- streaming

And three dimension spaces:
- euclid
- cosinus
- time series

## [distclus4py](https://github.com/wearelumenai/distclus4py)

Python connector for distclus.

## [evclus](https://github.com/wearelumenai/evclus)

Python distclus4py server with automatic pre-processing based on business data model schema, and specific output gateway.

## [bubbles](https://github.com/wearelumenai/bubbles)

Cluster visualisation tool with [d3js](https://d3js.org/).

## [bubbles4py](https://github.com/wearelumenai/bubbles4py)

Cluster visualisation tool based on **bubbles** and **distclus4py** for analyzing in a [ipython-notebook](https://jupyter.org/).

# Platform

We provide a more human-friendly solution for expert and common users aiming to analyze and visualize data model and clusters.

This solution is based on 5 services:

## Deployment

Clone the repository [tlotl](https://github.com/wearelumenai/tlotl).

```bash
git clone https://github.com/wearelumenai/tlotl
```

Then, read the [README](https://github.com/wearelumenai/tlotl/blob/master/README.md) for configuring your environment (dev, prod, distributed, etc.).

For example, taping

```bash
make
```

Will launch both platform and this documentation on your computer.

## Services

### [bubbles-app](https://github.com/wearelumenai/bubbles-app)

User interface for analyzing and visualizing data model.

Our SaaS is available at https://lakelady.lumenai.fr.

### [cluserve](https://github.com/wearelumenai/cluserve)

Batch/Online clustering server with graphql API and a playground.

Our SaaS is available at https://lakelady.lumenai.fr/tasks/graphql.

### [clustore](https://github.com/wearelumenai/clustore)

Bubbles-app backend with a graphql API at https://lakelady.lumenai.fr/store/playground.

Our SaaS is available at https://lakelady.lumenai.fr/store/playground.

### [tracking](https://github.com/wearelumenai/tracking)

Bubbles-app user interaction tracking service with a graphql API at https://lakelady.lumenai.fr/tracking/playground.

Our SaaS is available at https://lakelady.lumenai.fr/tracking/playground.

### [auth](https://github.com/wearelumenai/auth)

Authentication service.

Our SaaS is available at https://auth.lumenai.fr.

# What's next ?

Feel free to dive deep into the documentation to learn more about the architectural
design of The lady of the lake, or read the tutorials on how to use it.
