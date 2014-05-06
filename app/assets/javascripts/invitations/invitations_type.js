$(document).ready(function(){
  var selected_program = $(".program_option[selected='selected']");
  if ((selected_program !== null) && (selected_program.attr('value') !== undefined)){
    setInvitationLevel(selected_program.attr('value'));
  }
});