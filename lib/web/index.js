var flatiron;

flatiron = require('flatiron');

module.exports = function(port) {
  var app;
  app = flatiron.app;
  app.use(flatiron.plugins.http);
  app.router.get('/', function() {
    return this.res.html('<h1>Hello</h1>');
  });
  app.router.get('/login', function() {
    return this.res.html('<p>foo</p>');
  });
  return app.start(port);
};
