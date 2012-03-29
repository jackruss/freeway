module.exports = ->
  h1 'Configuration Options'
  form action: '/config', method: 'POST', ->
    # file
    textArea 'key'
    # file
    textArea 'cert'
    p ->
      button '.btn.btn-primary.btn-large', 'Configure'