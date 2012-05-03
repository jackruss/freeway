var auth, connect, creamer, ecstatic, flatiron;

flatiron = require('flatiron');

ecstatic = require('ecstatic');

creamer = require('creamer');

connect = require('connect');

auth = require(__dirname + '/middleware/auth');

module.exports = function(port) {
  var app;
  app = flatiron.app;
  app.use(flatiron.plugins.http, {});
  app.use(creamer, {
    views: __dirname + '/views',
    layout: require(__dirname + '/views/layout')
  });
  app.http.before = [
    ecstatic(__dirname + '/../public', {
      autoIndex: false,
      cache: true
    }), connect.cookieParser(), connect.session({
      secret: 'It is a lovely day for a long walk in the park'
    }), auth({
      exclude: ['login', 'sessions']
    })
  ];
  app.redirect = function(res, path) {
    res.writeHead(303, {
      Location: path
    });
    return res.end();
  };
  app.router.get('/', function() {
    return this.res.html(app.bind('index', {
      routes: 'active',
      user: this.req.session.user
    }));
  });
  app.router.get('/config', function() {
    return this.res.html(app.bind('config', {
      config: 'active',
      user: this.req.session.user
    }));
  });
  app.router.get('/login', function() {
    return this.res.html(app.bind('login'));
  });
  app.router.get('/logout', function() {
    var _this = this;
    return this.req.session.destroy(function(err) {
      return app.redirect(_this.res, '/login');
    });
  });
  app.router.post('/sessions', function() {
    var dest;
    this.req.session.user = this.req.body.user;
    this.req.session.maxAge = ((60 * 1000) * 60) * 24;
    this.req.session.save();
    dest = this.req.session.referrer;
    this.req.session.referrer = null;
    return app.redirect(this.res, '/');
  });
  return app.start(port);
};
