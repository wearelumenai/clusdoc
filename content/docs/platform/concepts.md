+++
title = "Description"
description = "Why and how ?"
date = 2019-12-03T21:43:35+01:00
weight = 1
draft = false
bref = "Why and how ?"
toc = true
+++

The platform is dedicated to more popular and common usage of lady of the lake tools, in order to make easier team-work between data-scientists and operationals

It provides two type of usages:
- [SaaS](/docs/platform/saas): full maintenaid and auto-updated solution for simpler and quicker use
- [On premise](/docs/platform/on_premise): *"à la carte"* solution with independent services and components for improving your business, from embedded to large scale systems

# Architecture

![Architecture](/media/platform.png)

# Concepts

The platform uses three main concepts for clustering your data

## Dataframe

Like the panda library, a dataframe contains definition of:

- size: data size in Bytes
- dim: data dimension
- columns: array of data column names
- chunks: array of data
- metadata: array of key, value with clustering meta information (iterations, duration, etc.)

## Dataset

A dataset has a name (unique per clustore/organization) and:
- id: universal unique identifier
- dataframe: data to clusterize

## Task

A task is the core concept in the `lady of the lake`

It contains information about:
- dataset: the dataset to clusterize
- identifier: dataset identifier column name
- variables: dataset columns to clusterize
- predictions: dataset columns to predict
- algorithm: algorithm parameters,
- dataset and clustering result

You can run it in cluserve, store results in clustore or see results in clusfront

## Algorithm

- name: mcmc, kmeans, streaming or future pluged in algorithm (graph will coming soon)
- flow: true if task is online clustering execution
- iter: maximal iterations to do
- space: data space
- innerSpace: inner composable space (dtw for example)
- dataPerIter: maximal data before ding iteration
- iterPerData: maximal iteration per data
- iterFreq: minimal iteration frequency (default 1/s)
- dataFreq: minimal data frequency (default 1/s)
- amp: mcmc amplitude
- mu: streaming mu
- k: number of kmeans centroids
- kInit: number of mcmc centroids at initialization
- timeout: maximal running duration
- window
- numCPU: maximal number of CPU to use
- frameSize: maximal frame size in bytes for clustering history
- parallel
- init: initialization algorithm (random, given, kmeans_pp)
