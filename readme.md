# Freeway

A wrapper around bouncy to build a two way proxy so that vendors can connect
to our cloud via one ip address.

## Why

To provide a single ip for external interfacing vendors for incoming
requests and outgoing requests.  Freeway can be configured to proxy
secure requests from one datacenter to dynamic load balancers that can
route to platform as a service applications in multiple datacenters.

## About

Freeway uses a simple couchdb for its configuration setup, this couchdb can be
configured by passing env params or by setting up a config.json file in the root 
of the application.  The config takes two keys, (uri and db)

Example Config

``` javascript
{
  "datastore": {
    "uri": "http://localhost:5984",
    "db": "freeway"
  }
}
```

Once a connection is made, freeway is going to look for two documents in the database.

1. opts
2. rules

The `opts` document contains any options you would like to pass to bouncy, for example SSL info to configure as a ssl terminator.

The `rules` document contains keys that define how the system will bounce per host match.

When a request comes into `freeway`, `freeway` will examine the headers `host` key to match against a key in the rules document, if a match is found then it will grab the value object of that key, which contains the url and port to execute the bounce for.

### Token Filter

Freeway has a feature that enables you to configure a `token` that can be validated to confirm that the proxy should perform the bounce.  If the `token` key is not set, it will always bounce, if it is set then freeway will validate the token before bouncing.

## Install

``` sh
npm install freeway -g
```

## Usage

create config json file - freeway.json

``` js
{
  "datastore": {
    "uri": "http://localhost:5984",
    "db": "freeway"
  }
}
```

``` sh
freeway
```

