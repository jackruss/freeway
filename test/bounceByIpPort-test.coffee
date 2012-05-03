process.env['datastore:uri'] = 'http://localhost:3030'
process.env['datastore:db'] = 'freeway'

freeway = require '../lib'
request = require 'request'
http = require 'http'

config = _id: 'rules', foo: { ip: '127.0.0.1', port: 3000 }

server = http.createServer (req, res) -> 
  res.writeHead 200, 'content-type': 'text/plain'
  res.end 'world'
server.listen 3000

couch = http.createServer (req, res) ->
  res.writeHead 200, 'content-type': 'application/json'
  if req.url == '/freeway/opts'
    res.end "{}"
  else if req.url == '/freeway/rules'
    res.end JSON.stringify(config)
couch.listen 3030

describe 'freeway', ->
  before (done) ->
    freeway(4000)
    done()
  describe 'features', ->
    it 'should bounce by ip and port', (done) ->
      request 'http://localhost:4000/hello', headers: { host: 'foo'}, (e, r, b) ->
        b.should.equal 'world'
        done()