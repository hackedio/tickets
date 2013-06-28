// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
  waitingTable();
  resolvedTable();
  initializeShowView();
});

// var refreshInterval = 1000;

// INDEX

function waitingTable() {
  var path = window.location.pathname;
  if ( path.match('tickets[\/]?$') ){
    ticketsData('waiting');
  };
}

function resolvedTable() {
  var path = window.location.pathname;
  if ( path.match('tickets[\/]?$') ){
    ticketsData('resolved');
  };
}

function ticketsData(status) {
  $.getJSON('/tickets.json', function(data) {
    var items = [];
     
    items.push('<tr> \
                <th>ticket no</th><th>seat</th> \
                <th>description</th><th>Group</th> \
                <th>waiting for ...</th><th></th> \
                </tr>'
    );

    $.each(data, function(key, val) {

      if(val['status'] == status){
        items.push(addDataToItems(val, status));
        if (status == 'waiting') {
          var date = new Date(val['created_at']);
          var element = '.timer-waiting'+val['id'];
          tickingTimer(date, element);  
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
  var timer = "timer-"+status+item['id'];

  var goToButton = "<a href='/tickets/"+item['id']+"'> \
                      <button class='btn btn-success'>Go To</button> \
                    </a>"

  return '<tr> \
          <td>' + item['ticket_no'] + '</td> \
          <td>' + item['seat'] + '</td> \
          <td>' + item['description'].substring(0,15) + '...</td> \
          <td>' + "" + '</td> \
          <td class='+timer+'>0</td> \
          <td>'+goToButton+'</td> \
          </tr>'
}

// function groupName(id){
//   var group = $.getJSON('/groups/'+id);
//   if (group.status == 200){
//     var groupname = group.responseJSON['name'];
//   }else{
//     var groupname = "No group assigned";
//   };
//   return groupname;
// }

function tickingTimer(dateThen, element) {
  setInterval(function() {
    var formattedTime = getFormattedTime(dateThen);
    $(element).html(formattedTime);
  }, 1000);
}

function getFormattedTime(dateThen){
    var dateNow = new Date();
    var sumDate = dateNow - dateThen;
    var date = new Date(sumDate);
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var seconds = date.getSeconds();
    var formattedTime = hours + 'h ' + minutes + 'm ' + seconds + 's';
    return formattedTime;
}

// SHOW

function initializeShowView() {
  var path = window.location.pathname;
  // if url is for tickets/:id
  if ( path.match('tickets\/[0-9]+$') ){
    displaySingleTicketData(path);
    initializeResolvedButton(path);
  };
}

function displaySingleTicketData(path) {
  $.getJSON(path+'.json', function(data){
    if(data['status'] != 'resolved'){
      date = new Date(data['created_at']);
      tickingTimer(date, '#waiting_for');
    }else{
      $('#waiting_for').html('0');
    };
  });
}

function initializeResolvedButton(path) {
  $('#resolved-button').click(function(){
    setTicketToResolved(path);
  });
}

function setTicketToResolved(path) {
  $.ajax({
    type: 'PUT',
    url: path,
    data: 'status=resolved',
    success: function(response) {
      $('#ticket-data').html(response['notice']);
    }
  });
}
