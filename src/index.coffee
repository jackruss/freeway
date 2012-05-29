bouncy = require 'bouncy'
nconf = require 'nconf'
follow = require 'follow'
nconf.env().file(file: "./config.json")

db = [nconf.get('datastore:uri'), nconf.get('datastore:db')].join('/')
freeway = require('nano')(db)
follow = require('follow')

tokens = {}
opts = {}
default = "https://iis-dev.eirenerx.com"

updateSettings =(settings) ->
  opts = { settings.key, settings.cert }
  tokens = settings.tokens
  default = settings.default
  # emit update settings

# # function loadRules
#
# pulls rules from couchdb config datastore
freeway.get 'settings', (e,doc) => 
  return console.error e if e
  updateSettings(doc)

# follow changes
follow db: db, include_docs: true, (e, change) =>
  return console.error e if e
  updateSettings(change.doc)

# if xtoken allow bouce to occur based on host header, otherwise bounce to default
module.exports = (port) ->
  
  server = bouncy opts, (req, bounce) =>
    xtoken = req.headers['x-token']
    target = default # set to default target
    target = if xtoken? and tokens.indexOf(xtoken) >= 0 then req.headers.host
    bounce target
  
  server.on "error", (err) -> console.error err.message
  server.listen port