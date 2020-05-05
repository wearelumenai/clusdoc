+++
title = "Clustore"
description = "Data storage"
date = 2019-12-03T21:41:29+01:00
weight = 30
draft = false
bref = "Data storage"
toc = true
+++

According to [Hasura](https://hasura.io), [Clustore](https://github.com/wearelumenai/clustore) provides 

# Concepts

In addition to [core concepts](/docs/platform/concepts), clustore provide team-work concepts :

## Organization

An organization represents a place to organize clustering between users

It uses

- id: [UUID](https://tools.ietf.org/html/rfc4122)
- name: unique per platform
- datasets: organization [datasets](/docs/platform/concepts#dataset)
- tasks: organization [tasks](/docs/platform/concepts#task)
- teams: organization [tasks](/docs/platform/concepts#task)

## Team

A team is a subset of users in an organization.

It uses

- id: [UUID](https://tools.ietf.org/html/rfc4122)
- name: unique per organization
- members: list of users which have the same right than the team (see [access](#access))

## Access

Define how a resource ([organization](#organization), [team](#team), [dataset](/docs/platform/concepts#dataset) and [task](/docs/platform/concepts#task)) interacts with the environment

> See [Clusauth access](/docs/platform/clusauth#access) for resource permission rights

- id: [UUID](https://tools.ietf.org/html/rfc4122)
- webhook: [event-trigger](#event-trigger)

## Tracking

Coupled with [Clusfront](/docs/platform/clusfront#tracking), a tracking is a notification of a user interaction

## Event trigger

According to [hasura event-trigger](https://hasura.io/docs/1.0/graphql/manual/event-triggers/payload.html#trigger-payload), an event trigger notifies a url when a resource is created/updated/deleted or when a tracking is created

# Configuration

TODO

# API

## REST requests:

The SaaS is available at https://dev.lakelady.fr/clustore

- GET [/ping](https://dev.lakelady.fr/clustore): pong if the service is available
- GET [/v1/graphql](https://dev.lakelady.fr/clustore/v1/graphql): graphql playground
- POST [/v1/graphql](https://dev.lakelady.fr/clustore/v1/graphql): graphql API

> Remember to add the http header `X-Clusauth-Token` if [Clusauth](/docs/platform/clusauth#token) exist in order to keep up your accesses

## Graphql Schema

### Fragments

```graphql
fragment UserFragment on user {
    id name
}
fragment TeamFragment on team {
    id name
    members {
        ...UserFragment
    }
}
fragment AccessFragment on access {
    id webhook adminToken contributorToken guestToken
    memberships {
        id webhook follow
        user {
            ...UserFragment
        }
        team {
            ...TeamFragment
        }
    }
}
fragment DataframeFragment on dataframe {
    id size dim columns metadata
    chunks {
        id size data
    }
}
fragment DatasetFragment on dataset {
    id name
    dataframe {
        ...DatasetFragment
    }
    owner {
        ...UserFragment
    }
}
fragment TaskFragment on task {
    id name
    owner {
        ...UserFragment
    }
    dataset {
        ...DatasetFragment
    }
    algorithm {
        name iter iterPerData dataPerIter iterFreq dataFreq mu amp k initK
        timeout window numCPU frameSize parallel init
    }
    identifier
    variables
    predictions
    centroids {
        ...DataframeFragment
    }
    labels {
        ...DataframeFragment
    }
}
fragment OrganizationFragment on organization {
    id createdAt updatedAt name
    owner {
        ...UserFragment
    }
    access {
        ...AccessFragment
    }
    tasks {
        ...TaskFragment
    }
    datasets {
        ...DatasetFragment
    }
    teams {
        id name members { id name }
    }
}
```

### Queries

Retrieve all accessible organizations, datasets, tasks and accesses

Parameters depend on [Hasura queries](https://hasura.io/docs/1.0/graphql/manual/queries/index.html)

```graphql
query {
    # get organizations and all its content
    organizations {
        ...OrganizationFragment
    }
    # get one organization by id
    organization(id: uuid!) {
        ...OrganizationFragment
    }
    # get datasets and all its content
    datasets {
        ...DatasetFragment
    }
    # get one dataset by id
    dataset(id: uuid!) {
        ...DatasetFragment
    }
    # get tasks and all its content
    tasks {
        ...TaskFragment
    }
    # get one task by id
    task(id: uuid!) {
        ...TaskFragment
    }
    # get accesses and all its content
    accesses {
        ...OrganizationFragment
    }
    # get one access by id
    access(id: uuid!) {
        ...OrganizationFragment
    }
    # get teams and all its content
    teams {
        ...TeamFragment
    }
    # get one team by id
    team(id: uuid!) {
        ...TeamFragment
    }
}
```

### Mutations

Generated with [Hasura logic](https://hasura.io/docs/1.0/graphql/manual/mutations/index.html)

### Subscriptions

Generated with [Hasura logic](https://hasura.io/docs/1.0/graphql/manual/subscriptions/index.html)
