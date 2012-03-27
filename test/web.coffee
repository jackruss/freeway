web = require '../lib/web'
request = require 'request'
browser = new require('zombie')

describe 'freeway', ->
  describe '#web(port)', ->
    before ->
      web 8000
    it 'GET "/" should redirect to login', (done) ->
      request 'http://localhost:8000/', (e, r, b) ->
        b.match(/id="user"/).should.be.ok
        b.match(/id="password"/).should.be.ok
        done()
    it 'should render login page', (done) ->
      request 'http://localhost:8000/login', (e, r, b) ->
        b.match(/id="user"/).should.be.ok
        done()
      # browser.visit 'http://localhost:8000/login', (e, browser) ->
      #   browser.query('input#user').should.be.ok
      #   browser.query('input#password').should.be.ok
      #   done()
