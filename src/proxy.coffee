bouncy = require 'bouncy'
nano = require('nano')
#utile = require('utile')

module.exports = (dbUrl, cb) ->
  db = nano(dbUrl).use('freeway')
  opts = {}
  rules = { 
    'mediture.eirenerx.com': { ip: "127.0.0.1", port: 3000, token: 'foobar' }
    'scripts.eirenerx.com': { ip: "192.168.1.1", port: 443 }
    'scripts.eirenerx.com': { url: 'http://elb-api.eirenerx.com' }
  }

  #utile.async.parallel [
  #  db.get 'sslkey', (e, b) -> opts.key = b.data
  #  db.get 'sslcert', (e, b) -> opts.cert = b.data
  #], ->
  bouncy opts, (req, bounce) -> 
    rule = rules[req.headers.host]
    bounce rule.ip, rule.port if rule?

