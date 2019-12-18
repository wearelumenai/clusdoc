+++
title = "Simple Application"
description = "Deploy your application easily"
date = 2019-12-04T11:29:49+01:00
weight = 20
draft = false
bref = "Deploy your application easily"
toc = true
+++

### datapio.yml

```
---
environments:
    production:
        branch: master
    preproduction:
        branch: dev

artifacts:
    - name: simple-app
      type: docker
      path: sources/simple-app
      params:
          dockerfile: docker/Dockerfile
          build-args:
              BASE_IMAGE: nginx:alpine

    - name: simple-app
      type: helm
      path: charts/simple-app
      requires:
        - name: simple-app
          type: docker
      params:
          set:
              some_const: "this is a constant"
              some_option: ${{ config.SOME_OPTION }}  # injected from Consul
              some_secret: ${{ secrets.SOME_SECRET }} # injected from Vault
```
