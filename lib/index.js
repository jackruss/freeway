var bouncy, db, follow, freeway, nconf, opts, rules;
var _this = this;

bouncy = require('bouncy');

nconf = require('nconf');

follow = require('follow');

nconf.env().file({
  file: "./config.json"
});

db = [nconf.get('datastore:uri'), nconf.get('datastore:db')].join('/');

freeway = require('nano')(db);

follow = require('follow');

rules = {};

opts = {};

freeway.get('rules', function(e, doc) {
  if (e) return console.error(e);
  rules = doc;
  return console.log(new Date() + ' - LOADED RULES');
});

freeway.get('opts', function(e, doc) {
  if (e) return console.error(e);
  opts = doc;
  return console.log(new Date() + ' - LOADED OPTIONS');
});

follow({
  db: db,
  include_docs: true
}, function(e, change) {
  if (e) return console.error(e);
  return rules = change.doc;
});

module.exports = function(port) {
  var server;
  var _this = this;
  server = bouncy(opts, function(req, bounce) {
    var rule;
    console.log(rules);
    rule = rules[req.headers.host];
    if (rule != null) {
      if ((rule.token != null) && rule.token !== req.headers['x-token']) return;
      if (rule.url != null) {
        bounce(rule.url);
      } else {
        bounce(rule.ip, rule.port);
      }
      return console.log(new Date() + ' - bounced to ' + JSON.stringify(rule));
    }
  });
  return server.listen(port);
};
