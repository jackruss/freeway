flatiron = require 'flatiron'
ecstatic = require 'ecstatic'
creamer = require 'creamer'

module.exports = (port) ->
  app = flatiron.app
  app.use flatiron.plugins.http
  app.use creamer, layout: ->
    doctype 5
    html ->
      head ->
        meta charset: 'utf-8'
        title 'Freeway Admin'
        link rel: 'stylesheet', href: '/css/bootstrap.min.css'
        link rel: 'stylesheet', href: '/css/bootstrap-responsive.min.css'
        link rel: 'stylesheet', href: '/css/app.css'
      body 'data-spy': 'scroll', 'data-target': '.subnav', 'data-offset': '50', ->
        div '.navbar.navbar-fixed-top', ->
          div '.navbar-inner',  ->
            div '.container', ->
              a '.brand', href: '/', 'Freeway'
              div '.nav-collapse', ->
                ul '.nav', ->
                  li -> a href: '/', 'Rules'
                  li -> a href: '/config', 'Config'
        div '.container', ->
          div '.row-fluid', ->
            div '.span8', -> content()
            div '.span4', ->
              div '.hero-unit', ->
                h2 'Freeway'
                p 'Proxy and Reverse Proxy'
                hr()
                h3 'Add Route'
                #p 'Add a route to freeway, the host represents the incoming host name and will be used to key the proxy.  The url or ip and port is the destination of the request.  Lastly, the token will enforce the sender to add X-token to their header.'
                div ->
                  form action: '/routes', method: 'POST', ->
                    textField 'host'
                    fieldset ->
                      textField 'target', placeholder: '(url or ip:port)'
                    textField 'token'
                    p '.help-block', 'Token will enforce callee to pass X-token header of this value'
                    button '.btn.btn-primary.btn-large', 'Add Route'

        script src: 'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.1/jquery.min.js'
        script src: '/js/bootstrap.min.js'

  app.http.before = [
      ecstatic __dirname + '/../public', autoIndex: off, cache: on
  ]

  app.router.get '/', ->
    @res.writeHead 303, Location: '/login'
    @res.end()

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
  app.start(port)


