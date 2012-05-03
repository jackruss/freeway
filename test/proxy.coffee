proxy = require '../lib/proxy'
request = require 'request'

http = require 'http'
server = http.createServer (req, res) -> 
  res.writeHead 200, 'content-type': 'text/plain'
  res.end 'world'
server.listen(3000)

describe 'proxy', ->
  describe 'on incoming request', ->
    it 'should bounce to localhost:3000', (done) ->
      config =
        "port": 4000
      server = proxy()
      server.listen config.port
      request 'http://localhost:4000/hello', (e, r, b) ->
        b.should.equal 'world'
        done()
