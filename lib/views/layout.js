
module.exports = function() {
  doctype(5);
  return html(function() {
    head(function() {
      meta({
        charset: 'utf-8'
      });
      title('Freeway Admin');
      link({
        rel: 'stylesheet',
        href: '/css/bootstrap.min.css'
      });
      link({
        rel: 'stylesheet',
        href: '/css/bootstrap-responsive.min.css'
      });
      return link({
        rel: 'stylesheet',
        href: '/css/app.css'
      });
    });
    return body({
      'data-spy': 'scroll',
      'data-target': '.subnav',
      'data-offset': '50'
    }, function() {
      div('.navbar.navbar-fixed-top', function() {
        return div('.navbar-inner', function() {
          return div('.container', function() {
            a('.brand', {
              href: '/'
            }, 'Freeway');
            return div('.nav-collapse', function() {
              return ul('.nav', function() {
                li(function() {
                  return a({
                    href: '/'
                  }, 'Rules');
                });
                return li(function() {
                  return a({
                    href: '/config'
                  }, 'Config');
                });
              });
            });
          });
        });
      });
      div('.container', function() {
        return div('.row-fluid', function() {
          div('.span8', function() {
            return content();
          });
          return div('.span4', function() {
            return div('.hero-unit', function() {
              h2('Freeway');
              p('Proxy and Reverse Proxy');
              hr();
              h3('Add Route');
              return div(function() {
                return form({
                  action: '/routes',
                  method: 'POST'
                }, function() {
                  textField('host');
                  fieldset(function() {
                    return textField('target', {
                      placeholder: '(url or ip:port)'
                    });
                  });
                  textField('token');
                  p('.help-block', 'Token will enforce callee to pass X-token header of this value');
                  return button('.btn.btn-primary.btn-large', 'Add Route');
                });
              });
            });
          });
        });
      });
      script({
        src: 'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.7.1/jquery.min.js'
      });
      return script({
        src: '/js/bootstrap.min.js'
      });
    });
  });
};
