log = console.log
pin = require 'linchpin'
bouncy = require 'bouncy'
nconf = require 'nconf'
follow = require 'follow'
nconf.env().file(file: "./config.json")

db = nconf.get('datastore')
freeway = require('nano')(db)
follow = require('follow')
opts = {}

nconf.set 'default', "https://localhost:9000"

updateSettings = (settings) ->
  if settings?
    nconf.set 'tokens', settings.tokens
    nconf.set 'default', settings.default if settings.default?
    log 'Updated Settings from CouchDb.....'

start = (port) ->
  # this may be buggy if settings are not set before bouncy is called.
  server = bouncy opts, (req, bounce) =>
    xtoken = req.headers['x-token']
    target = nconf.get('default') # set to default target
    if xtoken? and nconf.get('tokens').indexOf(xtoken) >= 0
      target = req.headers.host
    try
      bounce target
    catch err
      console.log err.message
      bounce 'http://www.eirenerx.com'

  server.on "error", (err) -> console.error err.message
  server.listen port

# get core settings
freeway.get 'settings', (e,doc) => 
  return log e if e
  updateSettings(doc) if doc._id == 'settings'

# follow changes
follow db: db, include_docs: true, (e, change) =>
  return log e if e
  updateSettings(change.doc)

pin.on 'getKEY', ->
  # setup certs
  freeway.attachment.get 'settings', 'eirenerx.com.key', (err, key) ->
    return log err if err?
    opts.key = key.toString()
    pin.emit 'getCERT'

pin.on 'getCERT', ->
  freeway.attachment.get 'settings', 'eirenerx.com.pem', (err, cert) ->
    return log err if err?
    opts.cert = cert.toString()
    pin.emit 'LOADED', null

module.exports = (port) ->
  log 'Welcome to Freeway v 1.0.0alpha3'
  pin.emit 'getKEY'
  log 'Initializing...'
  pin.on 'LOADED', (err) -> 
    log "Starting server on port #{port}..."
    start port
