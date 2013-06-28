// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
  initializeAddGroupButton();
  initializeAccordionText();
  initializeDeleteGroupButtons();
  initializeAddMemberButtons();
  clickEnterToSubmit();
});

function initializeAddGroupButton(){
  $('#add_group').click(function(){
    addNewGroupToDB();
  });
}

function clickEnterToSubmit() {
  $('#group_name').keypress(function(e) {
    if(e.which == 13) {
      $('#add_group').click();
    };
  });
}

function addNewGroupToDB() {
  var name = $('#group_name').val();
  $.post('/groups?name='+name);
  $('#collapseOne').collapse('hide');
  $('#group_name').val('');
  $('#all_groups').load('/groups #all_groups', function(){
    reloadGroupsCallback();
  });
}

function initializeAccordionText(){
  $('#collapseOne').on('show', function () {
    $('#accordion_add_group').text('- Add New Group');
    $('#group_name').focus();
  });
  $('#collapseOne').on('hide', function () {
    $('#accordion_add_group').text('+ Add New Group');
    $('#group_name').blur(); // removes focus
  });
}

function initializeDeleteGroupButtons() {
  $('.delete_group').click(function(){
    var groupid = $(this).data('groupid');
    var r = confirm("Are you sure you want to delete this group?");
    if (r==true){
      deleteGroup(groupid);
    };
  });
}

function deleteGroup(groupid){
  var path = '/groups/'+groupid;
  $.ajax({
    type: 'DELETE',
    url: path,
    success: function(response) {
      $('#all_groups').load('/groups #all_groups', function(){
        reloadGroupsCallback();
      });
    }
  });
}

function reloadGroupsCallback(){
  initializeDeleteGroupButtons();
  initializeAddMemberButtons();
}

function initializeAddMemberButtons(){
  $('.add_group_member').click(function(){
    var groupid = $(this).data('groupid');
    addGroupMember(groupid);
  });
}

function addGroupMember(groupid){
  var path = 'groups/'+groupid+'/users';
  var name = $('#member_name'+groupid).val();
  var msisdn = $('#msisdn'+groupid).val();
  $.ajax({
    type: 'POST',
    data: 'name='+name+'&msisdn='+msisdn,
    url: path,
    success: function(response) {
      if (response['alert']){
        alert(response['alert']);
      }else{
        $('#all_groups').load('/groups #all_groups', function(){
          reloadGroupsCallback();
        });
      };
    }
  });
}


