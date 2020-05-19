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

The SaaS is available at https://lakelady.fr/cluserve

- GET [/ping](https://lakelady.fr/cluserve/ping): pong response if service is available
- GET [/v1/graphql](https://lakelady.fr/cluserve/v1/graphql): graphql playground
- POST [/v1/graphql](https://lakelady.fr/cluserve/v1/graphql): graphql API

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

## Example with python and [requests](https://requests.readthedocs.io/en/master/)

This example does not show how to do subscription

### First, define your context

```python
from requests import post

# SaaS endpoint by default
cluserve_endpoint = 'https://cluserve.lakelady.fr'
graphql_endpoint = '{}/v1/graphql'.format(cluserve_endpoint)

# Construct an mcmc algorithm with three variables *color*, *weight* and *age* and specific dataset
task = {
    'name': 'test',
    'variables': ['color', 'weight', 'age'],
    'algorithm': {
        'name': 'mcmc'
    },
    'dataset': {
        # add specific dataset id if you want to retrieve clustore dataset
        'dataframe': {
            'chunks': [{
                'data': [[1, 2, 3]]
            }]
        }
    }
}

# run above task
resp = post(
    graphql_endpoint,
    json={
        'query': 'mutation Play($task: task!){ play(task: $task) { id } }',
        'variables': {'task': task}
    }
)

# raise if not 200
resp.raise_for_status()

body = resp.json()
errors = body.get('errors')
data = body.get('data')

if errors: # raise errors
    raise errors[0]

# get id
id = data['play']['id']
```

### Get status and centroids

```python
# get status and centroids
resp = post(
    graphql_endpoint,
    json={
        'query': 'Task(id: $id) { task(id: $id) { status centroids { chunks { data } } } }',
        variables: {'id': id}
    }
)

# raise if not 200
resp.raise_for_status()

body = resp.json()
errors = body.get('errors')
data = body.get('data')

if errors: # raise errors
    raise errors[0]

# get centroids and status
centroids = data['task']['centroids']['chunks'][0]['data']
status = data['task']['status']
```

### Push data

```python
data = [4, 5, 6]

# push data
post(
    graphql_endpoint,
    json={
        'query': 'Push($id: uuid!, $data: [Elemt!]!) { push(id: $id, data: $data) { status centroids { metadata } } }',
        'variables': {'id': id, 'data': data}
    }
)

# raise if not 200
resp.raise_for_status()

body = resp.json()
errors = body.get('errors')
data = body.get('data')

if errors: # raise errors
    raise errors[0]

# get metadata and figures
metadata = data['task']['centroids']['metadata']

iterations = metadata.get('iterations')
rho = metadata.get('rHo')
```

Enjoy !
