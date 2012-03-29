
module.exports = function() {
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
};
