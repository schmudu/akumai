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

function setInvitationLevel(program_value){
  $.get("/program_user_level.json", { program:program_value })
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
  }

$(document).ready(function(){
  function getHost(href) {
    var l = document.createElement("a");
    l.href = href;
    return l.protocol + "//" + l.host;
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

  $(".btn-cancel").click(function(){
    var jqxhr = $.get( "/invite_users/cancel.json", function() {
    })
      .done(function() {
        var host = getHost(window.location.href);
        var dashboard_url = host + "" + PATH_DASHBOARD;
        window.location.href = dashboard_url;
      })
      .fail(function(jqXHR, textStatus, errorThrown) {
        alert("Error: U001 - Cancel button.");
      });
  });

  $("#add_student_entries").click(function(){
    alert("inserting");
    // insert additional student entry rows
    var last_entry_row = $(".last_row").prev();
    var last_entry_id = last_entry_row.children(":first").children(":first").attr("id");
    var string_start = "attributes_";
    var start_length = string_start.length;
    var index_start =  last_entry_id.indexOf(string_start) + start_length;
    var string_end = "_email";
    var index_end = last_entry_id.indexOf(string_end);
    var last_row_num = last_entry_id.substr(index_start, index_end-index_start);
    //alert("last row number: " + last_row_num);

    var element_insert = $("<tr><td>Hello there</td><td></td></tr>");
    element_insert.insertAfter(last_entry_row);

  });

  $(".btn-cancel").attr('href', '#');

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
