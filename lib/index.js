var bouncy, db, follow, freeway, nconf, updateSettings;
var _this = this;

bouncy = require('bouncy');

nconf = require('nconf');

follow = require('follow');

nconf.env().file({
  file: "./config.json"
});

db = nconf.get('datastore');

freeway = require('nano')(db);

follow = require('follow');

nconf.set('default', "https://iis-dev.eirenerx.com");

updateSettings = function(settings) {
  nconf.set('opts', {
    key: settings.key,
    cert: settings.cert
  });
  nconf.set('tokens', settings.tokens);
  if (settings["default"] != null) nconf.set('default', settings["default"]);
  return console.log('Updated Settings from CouchDb.....');
};

freeway.get('settings', function(e, doc) {
  if (e) return console.error(e);
  return updateSettings(doc);
});

follow({
  db: db,
  include_docs: true
}, function(e, change) {
  if (e) return console.error(e);
  return updateSettings(change.doc);
});

module.exports = function(port) {
  var server;
  var _this = this;
  server = bouncy(nconf.get('opts'), function(req, bounce) {
    var target, xtoken;
    xtoken = req.headers['x-token'];
    target = nconf.get('default');
    if ((xtoken != null) && nconf.get('tokens').indexOf(xtoken) >= 0) {
      target = req.headers.host;
    }
    return bounce(target);
  });
  server.on("error", function(err) {
    return console.error(err.message);
  });
  return server.listen(port);
};
