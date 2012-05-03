var bouncy, db, follow, freeway, loadOpts, loadRules, nconf, opts, rules;

bouncy = require('bouncy');

nconf = require('nconf');

follow = require('follow');

nconf.env().file({
  file: "" + __dirname + "/config.json"
});

db = [nconf.get('datastore:uri'), nconf.get('datastore:db')].join('/');

freeway = require('nano')(db);

follow = require('follow');

rules = {};

opts = {};

loadRules = function() {
  return freeway.get('rules', function(e, doc) {
    if (e) return console.error(e);
    rules = doc;
    return console.log(new Date() + ' - LOADED RULES');
  });
};

loadRules();

loadOpts = function() {
  return freeway.get('opts', function(e, doc) {
    if (e) return console.error(e);
    rules = doc;
    return console.log(new Date() + ' - LOADED OPTIONS');
  });
};

loadOpts();

follow({
  db: db,
  include_docs: true
}, function(e, change) {
  if (e) return console.error(e);
  return rules = change.doc;
});

module.exports = function(cb) {
  return bouncy(opts, function(req, bounce) {
    var rule;
    rule = rules[req.headers.host];
    if (rule != null) return bounce(rule.ip, rule.port);
  });
};
