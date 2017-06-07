$(function() {
  addSelect2ToElement('select.task-tags-select');

  $('#report-form').on('cocoon:after-insert', function() {
    addSelect2ToElement('select.task-tags-select');
  });

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
