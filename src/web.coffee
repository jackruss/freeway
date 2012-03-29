flatiron = require 'flatiron'
ecstatic = require 'ecstatic'
creamer = require 'creamer'
connect = require 'connect'
auth = require __dirname + '/middleware/auth'


module.exports = (port) ->
  app = flatiron.app
  app.use flatiron.plugins.http

  app.use creamer, 
    views: __dirname + '/views'
    layout: require __dirname + '/views/layout'

  app.http.before = [
      ecstatic __dirname + '/../public', { autoIndex: off, cache: on }
      connect.cookieParser()
      connect.session secret: 'It is a lovely day for a long walk in the park'
      auth exclude: ['login','sessions']
  ]

  app.redirect = (res, path) ->
    res.writeHead 303, Location: path
    res.end()

  app.router.get '/', -> @res.html app.bind 'index', routes: 'active', user: @req.session.user
  app.router.get '/config', -> @res.html app.bind 'config', config: 'active', user: @req.session.user
  
  app.router.get '/login', -> @res.html app.bind 'login'
  app.router.get '/logout', -> @req.session.destroy (err) => app.redirect @res, '/login'

  app.router.post '/sessions', -> 
    # should go in resource/model
    @req.session.user = @req.body.user
    @req.session.maxAge = (((60 * 1000) * 60) * 24) # 24 hours
    @req.session.save()
    dest = @req.session.referrer
    @req.session.referrer = null

    app.redirect @res, '/'

  app.start(port)
