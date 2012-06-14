log = console.log
pin = require 'linchpin'
https = require 'https'
http = require 'http'
follow = require 'follow'
request = require 'request'

nconf = require 'nconf'
nconf.env().file(file: "./config.json")

db = nconf.get('datastore')
freeway = require('nano')(db)
follow = require('follow')
opts = {}

start = (port) ->
  server = https.createServer opts, (req, res) =>
  #server = http.createServer (req, res) =>
    req.on 'error', (e) -> 
      res.writeHead 500, 'content-type': 'text/plain'
      res.end "Could not connect to #{target}"
      log e.message
    
    method = req.method.toLowerCase()
    target = nconf.get('default') # set to default target
    xtoken = req?.headers['x-token']
    if xtoken? and nconf.get('tokens').indexOf(xtoken) >= 0 
      target = req.headers?.host

    dest = request[method](target + req.url, headers: req.headers)
    dest.on 'error', (e) ->
      msg = "ERROR: Could not connect to #{target} because #{e.message}"
      log msg
      res.writeHead 500, 'content-type': 'text/plain'
      res.end msg

    #bounce
    log "Bounced to #{target} on #{(new Date()).toString()}"
    try
      req.pipe(dest).pipe(res)
    catch err
      log err.message

  server.on "error", (err) -> 
    log err.message
  server.listen port

# follow changes
follow { db: db }, (e, change) =>
  return log e if e
  updateSettings() if change.id == 'settings'

updateSettings = ->
  freeway.get 'settings', (e,settings) => 
    return log e if e
    for own k,v of settings
      nconf.set(k, v) unless k[0] is '_' 
    pin.emit 'settings:loaded'
    log 'Updated Settings from CouchDb.....'

pin.on 'getKEY', ->
  # setup certs
  freeway.attachment.get 'settings', nconf.get('key'), (err, key) ->
    return log err if err?
    opts.key = key.toString()
    pin.emit 'getCERT'

pin.on 'getCERT', ->
  freeway.attachment.get 'settings', nconf.get('cert'), (err, cert) ->
    return log err if err?
    opts.cert = cert.toString()
    pin.emit 'LOADED', null

module.exports = (port) ->
  pin.once 'LOADED', (err) -> 
    log "Starting server on port #{port}..."
    start port
  
  updateSettings()
  pin.once 'settings:loaded', ->
    pin.emit 'getKEY'
    log 'Welcome to Freeway v 1.0.0alpha7'
    log 'Initializing...'
