$(document).ready(function(){
  $("#program_id").change(function(){
    //alert("program selected: " + $(this).val());
    $.get("/program_user_level.json", { program:$(this).val() })
      .done( function( data ){
        alert("done: " + data.message);
      });
  });
});
