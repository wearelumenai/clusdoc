+++
title = "Authentication"
description = "Standardized Single Sign On solution"
date = 2019-11-29T20:32:00+01:00
weight = 10
draft = false
bref = "Standardized Single Sign On solution"
toc = false
+++

We use the golang project [vouche-proxy](https://github.com/vouch/vouch-proxy) for authenticating users with standardized OpenID & Oauth2 providers.

Vouch-proxy is an SSO solution for Nginx using the [auth_request](http://nginx.org/en/docs/http/ngx_http_auth_request_module.html) module.

This service is mainly used by [clustore](/docs/clustore) for checking platform access rights.
