module.exports = ->
  div '.span4.well.offset2', ->
    h2 'Login'
    p 'Enter your username and password'
    form action: '/sessions', method: 'POST', ->
      textField 'user', input: { autofocus: "autofocus" }
      passwordField 'password'
      p ->
        button '.btn.btn-primary.btn-large', 'Login'