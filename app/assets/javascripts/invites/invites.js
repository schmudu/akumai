$(document).ready(function(){
  $("#user_email").focus(function(){
    setFormTextFocus("#user_email", INVITE_DEFAULT_EMAIL);
  });

  $("#user_email").click(function(){
    setFormTextFocus("#user_email", INVITE_DEFAULT_EMAIL);
  });

  $("#user_email").blur(function(){
    setFormTextBlur("#user_email", INVITE_DEFAULT_EMAIL);
  }); 

  $("#invite_student_id").focus(function(){
    setFormTextFocus("#invite_student_id", INVITE_DEFAULT_STUDENT_ID);
  });

  $("#invite_student_id").click(function(){
    setFormTextFocus("#invite_student_id", INVITE_DEFAULT_STUDENT_ID);
  });

  $("#invite_student_id").blur(function(){
    setFormTextBlur("#invite_student_id", INVITE_DEFAULT_STUDENT_ID);
  }); 

  $("#invite_code").focus(function(){
    setFormTextFocus("#invite_code", INVITE_DEFAULT_CODE);
  });

  $("#invite_code").click(function(){
    setFormTextFocus("#invite_code", INVITE_DEFAULT_CODE);
  });

  $("#invite_code").blur(function(){
    setFormTextBlur("#invite_code", INVITE_DEFAULT_CODE);
  }); 
});
