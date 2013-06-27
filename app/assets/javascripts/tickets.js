// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
  waitingTable();
  resolvedTable();
  // ticketsData();
});

var refreshInterval = 1000;

function ticketsData(status) {
  $.getJSON('/tickets.json', function(data) {
    var items = [];
     
    items.push('<tr> \
                <th>id</th><th>ticket no</th><th>seat</th> \
                <th>description</th><th>waiting for ...</th> \
                <th></th> \
                </tr>'
    );

    $.each(data, function(key, val) {
      if(val['status'] == status){
        items.push(addDataToItems(val, status));
        if (status == 'waiting') {
          tickingTimer(new Date(val['created_at']));
        };
      };
    });
   
    $('<table/>', {
      'class': 'table table-striped',
      html: items.join('')
    }).appendTo('#'+status);
  });
}

function addDataToItems(item, status) {
  var timer = "timer-"+status

  var goToButton = "<a href='/tickets/"+item['id']+"'> \
                      <button class='btn btn-success'>Go To</button> \
                    </a>"

  return '<tr> \
          <td>' + item['id'] + '</td> \
          <td>' + item['ticket_no'] + '</td> \
          <td>' + item['seat'] + '</td> \
          <td>' + item['description'].substring(0,15) + '...</td> \
          <td class='+timer+'>0</td> \
          <td>'+goToButton+'</td> \
          </tr>'
}

function waitingTable() {
  ticketsData('waiting');
}

function resolvedTable() {
  ticketsData('resolved');
}

function tickingTimer(dateThen) {
  var start = new Date;

  setInterval(function() {
    var dateNow = new Date();
    var sumDate = dateNow - dateThen;
    date = new Date(sumDate);
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var seconds = date.getSeconds();
    var formattedTime = hours + 'h ' + minutes + 'm ' + seconds + 's';

    $('.timer-waiting').html(formattedTime);
  }, 1000);
}