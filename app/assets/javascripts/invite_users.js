$(document).ready(function(){
  function enableAllUserLevels(){
    $(".admin").removeClass("disabled");
    $(".staff").removeClass("disabled");
    $(".student").removeClass("disabled");
  }

  function enableOnlyStudent(){
    uncheckRadioButton("input.admin");
    uncheckRadioButton("input.staff");

    $(".admin").addClass("disabled");
    $(".staff").addClass("disabled");
    $(".student").removeClass("disabled");
  }

  function disableAllUserLevels(){
    uncheckRadioButton("input.admin");
    uncheckRadioButton("input.staff");
    uncheckRadioButton("input.student");

    //alert("disable all users");
    $(".admin").addClass("disabled");
    $(".staff").addClass("disabled");
    $(".student").addClass("disabled");
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
