var auth, connect, creamer, ecstatic, flatiron;

flatiron = require('flatiron');

ecstatic = require('ecstatic');

creamer = require('creamer');

connect = require('connect');

auth = require(__dirname + '/middleware/auth');

module.exports = function(port) {
  var app;
  app = flatiron.app;
  app.use(flatiron.plugins.http);
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
  app.router.get('/', function() {
    return this.res.html(app.bind(function() {
      div('row', function() {
        return div('.well', function() {
          return h2('Routes');
        });
      });
      return div('row', function() {
        return table('.table.table-striped.table-bordered', function() {
          thead(function() {
            return tr(function() {
              th('host');
              th('target');
              return th('token');
            });
          });
          return tbody(function() {
            return tr(function() {
              td('mediture.eirenerx.com');
              td('http://api.mediture.com');
              return td('');
            });
          });
        });
      });
    }));
  });
  app.router.get('/login', function() {
    return this.res.html(app.bind(function() {
      return div('.span4.well.offset2', function() {
        h2('Login');
        p('Enter your username and password');
        return form({
          action: '/sessions',
          method: 'POST'
        }, function() {
          textField('user', {
            input: {
              autofocus: "autofocus"
            }
          });
          passwordField('password');
          return p(function() {
            return button('.btn.btn-primary.btn-large', 'Login');
          });
        });
      });
    }));
  });
  app.router.get('/logout', function() {
    var _this = this;
    return this.req.session.destroy(function(err) {
      console.log(err);
      _this.res.writeHead(303, {
        Location: '/login'
      });
      return _this.res.end();
    });
  });
  app.router.post('/sessions', function() {
    var dest;
    this.req.session.user = this.req.body.user;
    this.req.session.maxAge = ((60 * 1000) * 60) * 24;
    this.req.session.save();
    dest = this.req.session.referrer;
    this.req.session.referrer = null;
    this.res.writeHead(303, {
      Location: '/'
    });
    return this.res.end();
  });
  return app.start(port);
};
