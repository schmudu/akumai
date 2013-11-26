$(document).ready(function(){
  $("#program_id").change(function(){
    $.get("/program_user_level.json", { name:"Patrick" })
      .done( function( data ){
        alert("done: " + data.message);
      });
  });
});
