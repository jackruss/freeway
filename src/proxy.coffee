bouncy = require 'bouncy'
nconf = require 'nconf'
follow = require 'follow'
#utile = require('utile')
nconf.env().file(file: "#{__dirname}/config.json")
db = [nconf.get 'datastore:uri'), nconf.get 'datastore:db')].join('/')
freeway = require('nano')(db)
follow = require('follow')

rules = {}
opts = {}

# # function loadRules
#
# pulls rules from couchdb config datastore
loadRules = -> freeway.get 'rules', (e,doc) -> 
  return console.error e if e
  rules = doc
  console.log new Date() + ' - LOADED RULES'

loadRules()

# # function loadOpts
#
# pulls bouncy options from couchdb datastore
loadOpts = -> freeway.get 'opts', (e,doc) -> 
  return console.error e if e
  rules = doc
  console.log new Date() + ' - LOADED OPTIONS'

loadOpts()

# follow changes
follow db: db, include_docs: true, (e, change) ->
  return console.error e if e
  rules = change.doc

# proxy is driven by rules in config and dynamically
# reloaded every 5 minutes
module.exports = (cb) ->
  bouncy opts, (req, bounce) -> 
    rule = rules[req.headers.host]
    bounce rule.ip, rule.port if rule?