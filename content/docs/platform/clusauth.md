+++
title = "Clusauth"
description = "Single Sign On Service"
date = 2019-11-29T20:32:00+01:00
weight = 40
draft = false
bref = "Single Sign On Service"
toc = true
+++

[Clusauth](https://github.com/wearelumenai/clusauth) is the team-work service !

According to [vouch-proxy](https://github.com/vouch/vouch-proxy), it uses standardized protocols such as OpenID & Oauth2.

> Vouch-proxy is an SSO solution for Nginx using the [auth_request](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html) module.

You can test clusauth at https://lakelady.fr/clusauth

# Functionalities

## Bindings

Our SaaS solution uses OpenID/[auth0](https://auth0.com) for authenticating users through several 3rd auth providers such as Google and LinkedIN

According to vouch-proxy, here are exhaustive list of handled protocols :

- Google
- Github
- IndieAuth
- ADFS
- Homeassistant
- Nextclood
- Generic OpenID Connect

Tell us if you want to adapt our authentication service too your company authentication solution at : contact+lakelady@lumenai.com

## Rest requests

Here are REST queries

- GET `/login`: redirect user to SSO login page. If success, clusauth provides the header `X-Clusauth-User` with the user email and httpOnly cookie to use with lakelady services. A session last 3hr by default.
- GET `/validate`: returns the header `X-Clusauth-User` if logged in.
- GET `/auth`: try to `/validate`, otherwise, redirect to `/login`
- GET `/logout`: delete user session.
- GET `/token`: returns a 6 month jwt token to reuse with lakelady services.
- GET `/ping`: returns pong if the service is available

## Configuration

- `secret`: jwt secret

# Service interactions

`Clusauth` uses the concepts of `User` and `Access` for defining resource permissions in Clustore and Cluserve

## Access

According to membership role, an access defines access for `organization`, `team`, `dataset` and `task` for `public` use or per `user` and `team`

Values for membership role:
- `admin`: full right on resource + public access + invite and revoke admins.
- `contributor`: guest + can modify the resource content (execute task, add dataset in organization), revoke and invite contributors.
- `guest`: can see access and resource properties, and invite other guests.

A resource owner is `admin` of this resource

Properties

- `public`: membership role for everybody. For example, on https://lakelady.fr, everybody is contributor of the `organization` "*demo*"
- `adminToken`: token for having `admin` membership role to the resource
- `contributorToken`: token for having `contributor` membership role to the resource
- `adminToken`: token for having `guest` membership role to the resource
- `webhook`: url called for event-trigger
- `memberships`: list of memberships defined bellow

Membership

- `user`: user concerned by the membership
- `team`: team concerned by the membership
- `webhook`: specific user/team [event-trigger webhook](#event-trigger)
- `follow`: if true, the user/team will be notified about resource notifications
- `role`: user/team membership role

## Cluserve

[Cluserve](/docs/platform/cluserve) uses *Clusauth* for managing permissions to tasks and datasets interaction [accesses](/docs/platform/concepts#access)

An authenticated user can become a dataset/task owner

## Clustore

[Clustore](/docs/platform/clustore) uses the *Clusauth* service for checking access permission over *resources*: users, organizations, teams, datasets and tasks

Clustore uses three level of permission:

According to `owner` and `access` *resource* properties

- Admin: full rights over all resources
- User: authenticated user
- Anonymous: not loged in user. Has access to public resources
