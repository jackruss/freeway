module.exports = (options) ->
  (req, res, next) ->
    path = req.url.split('/').pop()
    excludes = options.exclude or []
    if req.session.user or excludes.indexOf(path) > -1 
     next()
    else
     req.session.referrer = req.originalUrl
     res.writeHead 303, Location: '/login'
     res.end()
  