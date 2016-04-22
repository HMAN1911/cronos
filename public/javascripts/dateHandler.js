$(document).ready(function() {

  $('#new_event').click(function(e) {
    var time = document.getElementById('start_time_entry').value
    var date = document.getElementById('start_date_entry').value
    var time2 = document.getElementById('end_time_entry').value
    var date2 = document.getElementById('end_date_entry').value
    var dateTime = date +  ' ' + time;
    var dateTime2 = date2 +  ' ' + time2;
    var mom = moment(dateTime, "YYYY-MM-DD HH:mm");
    var mom2 = moment(dateTime2, "YYYY-MM-DD HH:mm");
    var now = new moment;
    $.post("/results", { start_time: mom.unix() + '',
                        end_time  : mom2.unix() + '',
                        create_time: now.unix() + '',
                        event_name: document.getElementById('event_name').value
                      },
      function(result) {
        window.location = '/';
    });
  })

})
