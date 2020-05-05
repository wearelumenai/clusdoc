+++
title = "Cluserve"
description = "Online clustering server"
date = 2019-12-03T21:33:04+01:00
weight = 10
draft = false
bref = "Online clustering server"
toc = true
+++

[Cluserve](https://github.com/wearelumenai/cluserve) is a [task](/docs/platform/concepts#task) ordonnancer implemented in golang and reusing the [distclus tool](/docs/tools/distclus)

> Contact us at contact+lakelady@lumenai.fr for on-premise solution

# Configuration

# API

## REST requests

The SaaS is available at https://dev.lakelady.fr/cluserve

- GET [/ping](https://dev.lakelady.fr/cluserve/ping): pong response if service is available
- GET [/v1/graphql](https://dev.lakelady.fr/cluserve/v1/graphql): graphql playground
- POST [/v1/graphql](https://dev.lakelady.fr/cluserve/v1/graphql): graphql API

> Remember to add the http header `X-Clusauth-Token` if [Clusauth](/docs/platform/clusauth#token) exist in order to keep up your accesses

## Graphql Schema

### Fragments

```graphql
fragment AccessFragment on access {
    id adminToken contributorToken guestToken webhook memberships {
        id follow userId teamId webhook role
    }
}
fragment DataframeFragment on dataframe {
    id columns dim size metadata
    chunks {
        size data
    }
}
fragment DatasetFragment on dataset {
    id name
    dataframe {
        ...DataframeFragment
    }
}
fragment TaskFragment on task {
    id name identifier variables predictions
    algorithm {
        name iter dataPerIter iterPerData iterFreq dataFreq flow mu amp k kInit timeout space innerSpace window numCPU frameSize parallel init
    }
    dataset {
        ...DatasetFragment
    }
    centroids {
        ...DataframeFragment
    }
    labels {
        ...DataframeFragment
    }
}
```

### Queries

```graphql
query {
    # get processed tasks
    tasks(ids: [String!]) {
        ...TaskFragment
    }
    # get one task by id
    task(id: String!) {
        ...TaskFragment
    }
}
```

### Mutations

```graphql
mutation {
    # play a task
    play(task: TaskFragment) {
        ...TaskFragment
    }
    # pause a task by its id
    pause(id: String!) {
        ...TaskFragment
    }
    # stop a task by its id
    stop(id: String!) {
        ...TaskFragment
    }
    # push data to specific task
    push(data: [Elemt!]!, id: String!) {
        ...TaskFragment
    }
    # reconfigure a task
    reconfigure(task: TaskFragment) {
        ...TaskFragment
    }
    # copy a task by its id
    copy(id: String!) {
        ...TaskFragment
    }
    # delete a task by its id
    delete(id: String!) {
        ...TaskFragment
    }
}
```

### Subscription

Subscriptions are refreshed every 1.2s

```graphql
subscription {
    # subscribe to a task by its id
    task(id: String!) {
        ...TaskFragment
    }
}
```
