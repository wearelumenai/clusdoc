+++
title = "Simple Micro-Service"
description = "Deploy the business code of your micro-service"
date = 2019-12-04T11:30:01+01:00
weight = 30
draft = false
bref = "Deploy the business code of your micro-service"
toc = true
+++

### Business code

```js
module.exports = {
    initialize: async () => {
        const state = {}
        // ...
        return state
    },

    terminate: async (state) => {
        // ...
    },

    resolvers: async (state) => ({
        Query: {
            books: async (parent, args, context, info) => {
                return await context.prisma.books(info)
            }
        },
        Mutation: {
            addBook: async (parent, { author, title }, context, info) => {
                return await context.prisma.createBook({ author, title }, info)
            }
        }
    }),

    directives: async (state) => ({
        authenticated: async (next, source, args, context) => {
            // ...
            return await next()
        }
    })
}
```

### Kubernetes Resource

```
---
apiVersion: datap.io/v1
kind: MicroService
metadata:
    name: simple-microservice
spec:
    package: simple-microservice
    storage: 5Go
    datamodel: |
        type Book {
            author: String!
            title: String!
        }
    apiSchema: |
        directive @authenticated() on FIELD_DEFINITION

        Query {
            books: [Book!]!
        }

        Mutation {
            addBook(author: String!, title: String!): Book! @authenticated
        }
```
