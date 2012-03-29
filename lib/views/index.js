
module.exports = function() {
  div('row', function() {
    return div('.well', function() {
      return h2('Routes');
    });
  });
  return div('row', function() {
    return table('.table.table-striped.table-bordered', function() {
      thead(function() {
        return tr(function() {
          th('host');
          th('target');
          return th('token');
        });
      });
      return tbody(function() {
        return tr(function() {
          td('mediture.eirenerx.com');
          td('http://api.mediture.com');
          return td('');
        });
      });
    });
  });
};
