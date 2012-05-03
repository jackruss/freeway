bouncy = require 'bouncy'
nconf = require 'nconf'
follow = require 'follow'
#utile = require('utile')
nconf.env().file(file: "./config.json")

db = [nconf.get('datastore:uri'), nconf.get('datastore:db')].join('/')
freeway = require('nano')(db)
follow = require('follow')

rules = {}
opts = {}

# # function loadRules
#
# pulls rules from couchdb config datastore
freeway.get 'rules', (e,doc) => 
  return console.error e if e
  rules = doc
  console.log new Date() + ' - LOADED RULES'
# # function loadOpts
#
# pulls bouncy options from couchdb datastore
freeway.get 'opts', (e,doc) => 
  return console.error e if e
  opts = doc
  console.log new Date() + ' - LOADED OPTIONS'

# follow changes
follow db: db, include_docs: true, (e, change) =>
  return console.error e if e
  rules = change.doc

# proxy is driven by rules in config and dynamically
module.exports = (port) ->
  server = bouncy opts, (req, bounce) =>
    console.log rules 
    rule = rules[req.headers.host]
    if rule?
      # if token is configured the validate
      return if rule.token? and rule.token != req.headers['x-token']
      # bounce to destination
      if rule.url?
        bounce rule.url
      else
        bounce rule.ip, rule.port

      console.log new Date() + ' - bounced to ' + JSON.stringify(rule)
  server.listen port