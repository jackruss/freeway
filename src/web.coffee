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
      # ( (options) ->
      #   (req, res, next) ->
      #     path = req.url.split('/').pop()
      #     excludes = options.exclude or []
      #     if req.session.user or excludes.indexOf(path) > -1 
      #      next()
      #     else
      #      req.session.referrer = req.originalUrl
      #      res.writeHead 303, Location: '/login'
      #      res.end()
      # )(exclude: ['login','sessions'])
  ]

  #app.router.get '/', -> @res.html app.bind -> h1 'Hello World'
  app.router.get '/', -> @res.html app.bind -> 
    div 'row', ->
      div '.well', ->
        h2 'Routes'

    div 'row', ->
      table '.table.table-striped.table-bordered', ->
        thead ->
          tr ->
            th 'host'
            th 'target'
            th 'token'
        tbody ->
          tr ->
            td 'mediture.eirenerx.com'
            td 'http://api.mediture.com'
            td ''

  app.router.get '/login', -> @res.html app.bind ->
    div '.span4.well.offset2', ->
      h2 'Login'
      p 'Enter your username and password'
      form action: '/sessions', method: 'POST', ->
        textField 'user', input: { autofocus: "autofocus" }
        passwordField 'password'
        p ->
          button '.btn.btn-primary.btn-large', 'Login'
  app.router.get '/logout', -> 
    @req.session.destroy (err) =>
      console.log err 
      @res.writeHead 303, Location: '/login'
      @res.end()

  app.router.post '/sessions', -> 
    @req.session.user = @req.body.user
    @req.session.maxAge = (((60 * 1000) * 60) * 24)
    @req.session.save()

    dest = @req.session.referrer
    @req.session.referrer = null

    @res.writeHead 303, Location: '/'
    @res.end()

  app.start(port)


