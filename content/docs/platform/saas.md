+++
title = "SaaS"
description = "Software as a Service"
date = 2019-12-03T21:43:35+01:00
weight = 2
draft = false
bref = "Software as a Service"
toc = true
+++

The platform is available such as a SaaS at https://dev.lakelady.fr

All platform services are available at a price, depending on your needs

# Usage levels

1. Anonymous: as a guest, you can see content of the public organization at https://dev.lakelady.fr?org=public, execute and change parameters of tasks
2. logged in user: as an identified use, you can create 5 private tasks, with datasets of at most 50MB
3. subscriber: after subscribing to a plan of 9€/month, you can use the [pay as you go](#pay-as-you-go) plan, in the limit of datasets of 1GB
4. accompagnied: you can hire a data-scientist to assist you in your clustering
5. "à la carte": you can install your own version of the platform with the [On premise](/docs/platform/on_premise) solution

> For 4. and 5. levels, contact our commercial team at contact+lakelady@lumenai.f

# Pay as you go

Here is the `subscription` plan beginning 9€/month

As mathematicians, we take care of statistics and precise accounting

In such a way, we prefer the solution `pay as you go` with a threshold to not exceed in order to avoid bad surprises

Therefore, for every [task](/docs/platform/concepts#task) and [dataset](/docs/platform/concepts#dataset) you use, the platform provides:
- price per month since the creation step
- global price information page at https://dev.lakelady.fr/#/pricing

Here are computer resources you will pay as a `subscriber`

## Resources

### ROM

Only datasets are impacted by this metric

Use:
- size: in bytes more than 100MB
- duration: in seconds
- cost:

Formulae:

```python
(0 if size <= 100MB else size) * duration * cost
```

### Computing time

Only tasks are impacted by this metric.

Use:
- duration: [Running](/docs/tools/distclus#status) status duration
- iter: number of iterations
- rowSize: row size in bytes
- frameSize: in bytes
- numCPU: [allocated CPU](/docs/platform/concepts#algorithm).
- cost: 

Formulae:

```python
duration * iter * rowSize * frameSize * numCPU * cost
```

### RAM

Only tasks are impacted by this metric.

Use:
- frameSize: clustering history greater than 100MB
- parallel: [algorithm parallelization](/docs/platform/concepts#algorithm) equals 0 or 1
- duration: cluserve task duration
- cost:

Formulae:

```python
(0 if frameSize <= 100MB else frarmeSize) * duration * (2 if parallel else 0) * cost
```

### network bandwidth

depend on number of data you push

Use:
- pushedData: number of pushed data
- rowSize: row size in bytes
- cost:

Formulae:

```python
pushedData * rowSize * cost
```

# Market place

You can enrich your platform session with additional components available in the market place: https://dev.lakelady.fr/clusmarket

You can command a [specific development](contact+lakelady@lumenai.fr), or contribute in sharing your own, and even sell it on our platform

