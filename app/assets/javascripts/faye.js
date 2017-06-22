$(function() {
  faye = new Faye.Client('http://localhost:9292/faye');
  faye.subscribe('/reports/new', function(data) {
    console.log(data);

    $.ajax({
      url: '/reports/add_report',
      data: { report_id: data['id'] },
      dataType: 'script',
      type: 'POST'
    });
  });
});
