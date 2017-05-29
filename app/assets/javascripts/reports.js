$(function() {
  console.log( "ready!" );

  addSelect2ToElement('select.task-tags-select');

  $('#report-form').on('cocoon:after-insert', function() {
    addSelect2ToElement('select.task-tags-select');
  });

  function addSelect2ToElement(element) {
     //TODO: add AJAX call to fetch data
    $(element).select2({
      theme: 'bootstrap',
      language: 'ru'
    });
  }
});
