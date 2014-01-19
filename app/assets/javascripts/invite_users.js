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

  /*
  $(".btn-cancel").click(function(){
    alert("cancel called.");
    $.post("/invite_users/cancel.json", function( data ){
        alert("done clearing variables");
      }).
      fail(function() {
        alert("error:");
      });
    });
  });
*/

  $(".btn-cancel").click(function(){
    var jqxhr = $.get( "/invite_users/cancel.json", function() {
    })
      .done(function() {
        alert("done2:" + URL_DASHBOARD);
        window.location.href = URL_DASHBOARD;
      })
      .fail(function(jqXHR, textStatus, errorThrown) {
        alert("error");
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
