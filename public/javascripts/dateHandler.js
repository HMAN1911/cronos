$(document).ready(function() {

  $('#new_event').click(function(e) {
    var time = document.getElementById('time_entry').value
    var date = document.getElementById('date_entry').value
    var dateTime = date +  ' ' + time;
    var mom = moment(dateTime, "YYYY-MM-DD HH:mm");
    var now = new moment;
    $.post("results", { start_time: mom.unix() + '',
                        end_time  : mom.unix() + '',
                        create_time: now.unix() + '',
                        event_name: document.getElementById('event_name').value
                      },
      function(result) { 
        window.location = '/error';
    });
  })

})