module.exports = ->
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
  