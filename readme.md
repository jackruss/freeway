# Freeway

A node proxy with a web management console for managing incoming and
outgoing requests.

## Why

To provide a single ip for external interfacing vendors for incoming
requests and outgoing requests.  Freeway can be configured to proxy
secure requests from one datacenter to dynamic load balancers that can
route to platform as a service applications in multiple datacenters.

## Install

``` sh
npm install freeway -g
```

## Usage

create config json file - freeway.json

``` js
{
  "proxy": 4000,
  "web": {
     user: "admin",
     password: "admin"
  },
  "db": "http://localhost:5498"
}
```

``` sh
freeway
```

