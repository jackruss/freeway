
module.exports = function() {
  h1('Configuration Options');
  return form(function() {
    textArea('key');
    textArea('cert');
    return p(function() {
      return button('.btn.btn-primary.btn-large', 'Configure');
    });
  });
};
