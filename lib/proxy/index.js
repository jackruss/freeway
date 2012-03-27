var bouncy, nano;

bouncy = require('bouncy');

nano = require('nano');

module.exports = function(dbUrl, cb) {
  var db, opts, rules;
  db = nano(dbUrl).use('freeway');
  opts = {};
  rules = {
    'mediture.eirenerx.com': {
      ip: "127.0.0.1",
      port: 3000,
      token: 'foobar'
    },
    'scripts.eirenerx.com': {
      ip: "192.168.1.1",
      port: 443
    },
    'scripts.eirenerx.com': {
      url: 'http://elb-api.eirenerx.com'
    }
  };
  return bouncy(opts, function(req, bounce) {
    var rule;
    rule = rules[req.headers.host];
    if (rule != null) return bounce(rule.ip, rule.port);
  });
};
