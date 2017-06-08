$(function() {
  addSelect2ToElement('select.task-tags-select');

  $('#report-form').on('cocoon:after-insert', function() {
    addSelect2ToElement('select.task-tags-select');
  });

  //setup before functions
  var typingTimer;                //timer identifier
  var doneTypingInterval = 1000;  //time in ms (2 seconds)

  //on keyup, start the countdown
  $('#report_search_form').on('keyup', function(e){
    console.log('type');
    var term = e.target.value;
    clearTimeout(typingTimer);
    typingTimer = setTimeout(function() { searchReport(term) }, doneTypingInterval);
  });

  function searchReport(term) {
    console.log('search');
    $.ajax({
      url: '/reports',
      timeout: 9000,
      data: { by_search: term },
      dataType: 'script',
      error: function(jqXHR, textStatus, errorThrown){
        console.log(textStatus);
      },
      success: function(jqXHR, textStatus){
        console.log(textStatus);
      }
    });
  };

  function addSelect2ToElement(element) {
    $(element).select2({
      ajax: {
        url: '/tags',
        dataType: 'json',
        delay: 250,
        data: function (params) {
          return {
            by_name: params.term
          };
        },
        processResults: function (data, params) {
          return {
            results: $.map( data, function( el, i ) {
              return { id: el['id'], text: el['name'] }
            })
        };
        },
        cache: true
      },
      escapeMarkup: function (markup) { return markup; }
      //minimumInputLength: 1
    });
  }
});
