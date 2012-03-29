module.exports = -> 
  div 'row', ->
    div '.well', ->
      h2 'Routes'

  div 'row', ->
    table '.table.table-striped.table-bordered', ->
      thead ->
        tr ->
          th 'host'
          th 'target'
          th 'token'
      tbody ->
        tr ->
          td 'mediture.eirenerx.com'
          td 'http://api.mediture.com'
          td ''  