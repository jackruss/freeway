bouncy = require 'bouncy'
nconf = require 'nconf'
follow = require 'follow'
nconf.env().file(file: "./config.json")

db = nconf.get('datastore')
freeway = require('nano')(db)
follow = require('follow')

nconf.set 'default', "https://localhost:9000"

updateSettings = (settings) ->
  nconf.set 'opts', { key: settings.key, cert: settings.cert }
  nconf.set 'tokens', settings.tokens
  nconf.set 'default', settings.default if settings.default?
  console.log 'Updated Settings from CouchDb.....'

# pulls rules from couchdb config datastore
freeway.get 'settings', (e,doc) => 
  return console.error e if e
  updateSettings(doc) if doc._id == 'settings'

# follow changes
follow db: db, include_docs: true, (e, change) =>
  return console.error e if e
  
  updateSettings(change.doc)

# if xtoken allow bouce to occur based on host header, otherwise bounce to default
module.exports = (port) ->
  # this may be buggy if settings are not set before bouncy is called.
  server = bouncy nconf.get('opts'), (req, bounce) =>
    xtoken = req.headers['x-token']
    target = nconf.get('default') # set to default target
    if xtoken? and nconf.get('tokens').indexOf(xtoken) >= 0
      target = req.headers.host
    bounce target
  
  server.on "error", (err) -> console.error err.message
  server.listen port