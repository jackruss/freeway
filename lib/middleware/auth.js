
module.exports = function(options) {
  return function(req, res, next) {
    var excludes, path;
    path = req.url.split('/').pop();
    excludes = options.exclude || [];
    if (req.session.user || excludes.indexOf(path) > -1) {
      return next();
    } else {
      req.session.referrer = req.originalUrl;
      res.writeHead(303, {
        Location: '/login'
      });
      return res.end();
    }
  };
};
