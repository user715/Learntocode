function submit_match_stats(event){
  event.preventDefault();
  $.ajax({
      url: "/matches/" + $('#match_details').attr('value'),
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      type: "put",
      data: {},
      success: function(data) {console.log('submitted successfully!')}
  });
  console.log('hehe');
}

function create_tag(event){
  event.preventDefault();
  $.ajax({
    url: '/categories',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    type: 'post',
    data: {'name': document.getElementById('new_tag_text').innerHTML},
    success: function(data) {console.log('Created tag successfully!')}
  });
}
  // $(document).on('ajax:complete', '.last_submission', function(event, data, status, xhr) {
  //   alert("Response is => " + data)
  // });