# Freeway

A reverse proxy webserver

Freeway has the following configuration settings that are stored in a couchdb document called
settings.  

```
{
  "default": "http://internal.server.com", // your internal servers or load balancers
  "tokens": ["foo", "bar", "baz"]
}
```

Any request that comes into the server without a token in the header that matches the
configured tokens will bounce to the default server.  Any request that comes into the
server with a matching token will bounce to the host header in the request.

## Install

``` sh
npm install freeway -g
```

## Usage

create config json file - config.json

``` js
{
  "datastore": "http://localhost:5984/freeway"
}
```

``` sh
freeway 8080
```

## Logging 

All logs are currently going to stdout, if you use forever you can also configure this.

