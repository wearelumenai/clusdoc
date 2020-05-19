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
            'columns': ['color', 'weight', 'age'],
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
        'query': 'mutation Play($task: TaskInput!){ play(task: $task) { id } }',
        'variables': {'task': task}
    }
)

# raise if not 200
resp.raise_for_status()

body = resp.json()
errors = body.get('errors')
data = body.get('data')

if errors: # raise errors
    raise Exception(errors[0]['message'])

# get id
id = data['play']['id']
```

### Get status and centroids

```python
# get status and centroids
resp = post(
    graphql_endpoint,
    json={
        'query': 'Task($id: String!) { task(id: $id) { status centroids { chunks { data } } } }',
        variables: {'id': id}
    }
)

# raise if not 200
resp.raise_for_status()

body = resp.json()
errors = body.get('errors')
data = body.get('data')

if errors: # raise errors
    raise Exception(errors[0]['message'])

# get centroids and status
centroids = data['task']['centroids']['chunks'][0]['data']
status = data['task']['status']
```

### Push data

```python
data = [4, 5, 6]
dataframe = {
    'columns': ['color', 'weight', 'age'],
    'chunks': [{
        'data': data
    }]
}

# push data
post(
    graphql_endpoint,
    json={
        'query': 'PushData($id: uuid!, $data: [Elemt!]!) { pushData(id: $id, $dataframe: DataframeInput!) { status centroids { metadata } } }',
        'variables': {'id': id, 'dataframe': dataframe}
    }
)

# raise if not 200
resp.raise_for_status()

body = resp.json()
errors = body.get('errors')
data = body.get('data')

if errors: # raise errors
    raise Exception(errors[0]['message'])

# get metadata and figures
metadata = data['task']['centroids']['metadata']

iterations = metadata.get('iterations')
rho = metadata.get('rHo')
```

# On-premise

## Configuration

Done first by environment variables, then by configuration file.

> In production mode, remember to build project (`make build` or `make docker-build`) after modifying the configuration

### Environment variables

We discourage this practice for seacurity reasons.

- CLUSERVE_ENDPOINT: cluserve endpoint. Default is http://cluserve:8002
- CLUSERVE_KEYFILE: cluserve ssl keyfile path
- CLUSERVE_CERTFILE: cluserve ssl certificate file path
- CLUSERVE_DOMAINS: cluserve domains for CORS. Default all
- CLUSERVE_SENTRY: cluserve [sentry dsn](https://sentry.io/for/go/)
- CLUSERVE_TIMEOUT: request timeout in seconds. Default 180
- CLUSERVE_DEBUG: log debug information

#### Services

- CLUSAUTH_ENDPOINT: clusauth endpoint. Default is http://clusauth:8003
- CLUSTORE_ENDPOINT: clustore endpoint. Default is http://clustore:8001

#### Docker compose

- CLUSERVE_CONTEXT: root project directory. Default is ..
- CLUSERVE_DOCKERFILE: dockerfile path from context. Default is build/Dockerfile
- CLUSERVE_IMAGE: cluserve image name. Default is cluserve[:dev]
- CLUSERVE_CONTAINER: cluserve container name. Default is cluserve[-dev]
- CLUSERVE_PORT: local port. Default is 8002

### Configuration file

Then from one configuration file: `configs/config.(yml|yaml|toml|json)`:

If this file does not exist, you can copy one of the `configs/config.sample.(yml|yaml|toml|json)` files:

Example of yaml file:

```yml
cluserve:
  endpoint: http://cluserve:8002
  keyfile: '' # path to ssl key
  certfile: '' # path to ssl certificate
  domains: [] # accepted domains by CORS. Default all
  sentry: '' # sentry dsn
  timeout: 180 # request timeout in seconds

clusauth:
  endpoint: http://clusauth:8003

clustore:
  endpoint: http://clustore:8001
```

> Only one configuration file will be loaded and you will be notified in logs.

> According to environment concerns (development,test,production), you can add primary configuration files with the name `config.(development|test|production).(yml|yaml|json|toml)` which will override `config.(yml|yaml|json|toml)` content. The environment has to be setted with the env variable `CONFIGOR_ENV` (development by default)

## Build, test and install

> require
- [make](http://www.gnu.org/software/make/)

```bash
make
```

Do:
- get go dependencies
- build cluserve in source directory (use `make install` for installing it in `${GOPATH}/bin/cluserve`)

## Usage

Provide service at `http://localhost:8002/v1/graphql` where `v1` is the graphql API version where methods are :

- GET: playground
- POST: query and mutation
- WS: subscription

```bash
# start server
make start
# start server with hot-reload
make dev
```

## With docker

> Require [docker-compose](https://docs.docker.com/compose/install/)

Mount the configuration file such as a volume and expose service at http://localhost:8002/v1/graphql

```bash
make docker-up
# or with args : for example, for building before launching the container in detached mode => docker-compose up --build -d
ARGS="--build" make docker-up
# or in development mode (hot-reload)
make docker-dev-up
```

> Other commands are docker-\[dev-](build|stop|down|logs|restart|config|tty|cmd) where cmd permits to custom docker-compose command with env var CMD: `CMD=events make docker-cmd` equivalent to docker-compose -p lakelady -f deployments/docker-compose.yml events

Enjoy !
