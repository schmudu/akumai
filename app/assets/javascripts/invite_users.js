$(document).ready(function(){
  function enableAllUserLevels(){
    $("#level_admin").removeClass("disabled");
    $("#level_staff").removeClass("disabled");
    $("#level_student").removeClass("disabled");
  }

  function enableOnlyStudent(){
    //admin_check = $("#level_admin").is(':checked');
    if($("#level_admin").is(':checked') == true)
      $("#level_admin").prop('checked', false);

    if($("#level_staff").is(':checked') == true)
      $("#level_staff").prop('checked', false);

    //alert("only student");
    $("#level_admin").addClass("disabled");
    $("#level_staff").addClass("disabled");
    $("#level_student").removeClass("disabled");
  }

  function disableAllUserLevels(){
    //alert("disable all users");
    $("#level_admin").addClass("disabled");
    $("#level_staff").addClass("disabled");
    $("#level_student").addClass("disabled");
  }

  $("#program_id").change(function(){
    //alert("program selected: " + $(this).val());
    $.get("/program_user_level.json", { program:$(this).val() })
      .done( function( data ){
        var user_level = data.level;
        if (user_level == LEVEL_ROLE_SUPERUSER){
          enableAllUserLevels();
        }
        else if (user_level == LEVEL_ROLE_ADMIN){
          enableAllUserLevels();
        }
        else if (user_level == LEVEL_ROLE_STAFF){
          enableOnlyStudent();
        }
        else if (user_level == LEVEL_ROLE_STUDENT){
          disableAllUserLevels();
        }
      });
  });
});
