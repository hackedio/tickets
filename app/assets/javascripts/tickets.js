// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
  initializeIndexView()
  initializeShowView();
});

// INDEX

function initializeIndexView() {
  var path = window.location.pathname;
  // if path is root or /tickets...
  if ( path.match('tickets\/?$|^\/?$') ){
    setInitialTime();
    initializeTickingTimer()
  };
}

function setInitialTime() {
  var ticketsWaiting = $('.timer-waiting');

  $.each(ticketsWaiting, function(key,val){
    var createdAt = $(val).data('createdat');
    var dateThen = new Date(createdAt);
    var formattedTime = getFormattedTime(dateThen);
    $(val).html(formattedTime);
  });
}

function initializeTickingTimer() {
  var ticketsWaiting = $('.timer-waiting');

  $.each(ticketsWaiting, function(key,val){
    var createdAt = $(val).data('createdat');
    var dateThen = new Date(createdAt);
    tickingTimer(dateThen, val);
  });
}

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
