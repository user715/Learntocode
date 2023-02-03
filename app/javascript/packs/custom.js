$(function() {
  $('.last_submission').on('ajax:success', addBook)
  function addBook(event, data,status, xhr) {
   console.log(status);
   alert(status);
   $('.enter-code-ta').html(data)
 }
 
});

  // $(document).on('ajax:complete', '.last_submission', function(event, data, status, xhr) {
  //   alert("Response is => " + data)
  // });