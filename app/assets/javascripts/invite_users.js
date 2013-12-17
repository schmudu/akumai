$(document).ready(function(){
  function enableAllUserLevels(){
    $(".admin").removeClass("disabled");
    $("#radio_admin").attr("disabled", false);
    $(".staff").removeClass("disabled");
    $("#radio_staff").attr("disabled", false);
    $(".student").removeClass("disabled");
    $("#radio_student").attr("disabled", false);
  }

  function enableOnlyStudent(){
    uncheckRadioButton("input.admin");
    uncheckRadioButton("input.staff");

    $(".admin").addClass("disabled");
    $("#radio_admin").attr("disabled", true);
    $(".staff").addClass("disabled");
    $("#radio_staff").attr("disabled", true);
    $(".student").removeClass("disabled");
    $("#radio_student").attr("disabled", false);
  }

  function disableAllUserLevels(){
    uncheckRadioButton("input.admin");
    uncheckRadioButton("input.staff");
    uncheckRadioButton("input.student");

    $(".admin").addClass("disabled");
    $("#radio_admin").attr("disabled", true);
    $(".staff").addClass("disabled");
    $("#radio_staff").attr("disabled", true);
    $(".student").addClass("disabled");
    $("#radio_student").attr("disabled", true);
  }

  $("#program_id").change(function(){
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

  $("#email_addresses").focus(function(){
    setFormTextFocus("#email_addresses", EMAIL_ADDRESSES_DEFAULT);
  });

  $("#email_addresses").click(function(){
    setFormTextFocus("#email_addresses", EMAIL_ADDRESSES_DEFAULT);
  });

  $("#email_addresses").blur(function(){
    setFormTextBlur("#email_addresses", EMAIL_ADDRESSES_DEFAULT);
  });

  // init methods
  setFormTextBlur("#email_addresses", EMAIL_ADDRESSES_DEFAULT);
});
