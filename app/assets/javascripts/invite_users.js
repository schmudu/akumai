$(document).ready(function(){
  $("#program_id").change(function(){
    //alert("on change.");
    $.get("/program_user_level.json")
      .done( function( data ){
        alert("done: " + data);
      });
    /*
    $.get("/program_user_level.json", function(){
      alert("success");
    })
      .done(function(data) {
        alert("data loaded: " + data);
      })
      .fail(function() {
        alert("error");
      });*/
  });
});
