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
    initializeTickingTimer();
    loopReloadTickets();
  };
}

function loopReloadTickets() {
  setInterval(function(){
    reloadTickets();
  }, 5000);
}

function reloadTickets() {
  $('#resolved').load('/tickets #resolved');
  $('#waiting').load('/tickets #waiting', function(){
      reloadTicketsCallback();
  });
}

function reloadTicketsCallback(){
  setInitialTime();
  initializeTickingTimer();
}

function setInitialTime() {
  var ticketsWaiting = $('.timer-waiting');

  $.each(ticketsWaiting, function(key,val){
    var createdAt = $(val).data('createdat').replace("UTC","GMT");
    var dateThen = Date.parse(createdAt);
    var formattedTime = getFormattedTime(dateThen);
    $(val).html(formattedTime);
  });
}

function initializeTickingTimer() {
  var ticketsWaiting = $('.timer-waiting');

  $.each(ticketsWaiting, function(key,val){
    var createdAt = $(val).data('createdat').replace("UTC","GMT");
    var dateThen = Date.parse(createdAt);
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
    var dateNow = Date.now();
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
    setInitialSingleTicketTime();
    displaySingleTicketTimer(path);
    initializeResolvedButton(path);
  };
}

function setInitialSingleTicketTime() {
  var status = $('#status').html();
  if (status == 'waiting'){
    var createdat = $('#waiting_for').data('createdat').replace("UTC","GMT");
    var dateThen = Date.parse(createdat);
    var formattedTime = getFormattedTime(dateThen);
    $('#waiting_for').html(formattedTime);
  }
}

function displaySingleTicketTimer(path) {
  var status = $('#status').html();
  if(status == 'waiting'){
    var createdat = $('#waiting_for').data('createdat').replace("UTC","GMT");
    var date = Date.parse(createdat);
    tickingTimer(date, '#waiting_for');
  };
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
      console.log(response);
    }
  });
}
