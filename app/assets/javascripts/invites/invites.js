$(document).ready(function(){
  $("#invite_student_id").focus(function(){
    setFormTextFocus("#invite_student_id", INVITE_DEFAULT_STUDENT_ID);
  });

  $("#invite_student_id").click(function(){
    setFormTextFocus("#invite_student_id", INVITE_DEFAULT_STUDENT_ID);
  });

  $("#invite_student_id").blur(function(){
    setFormTextBlur("#invite_student_id", INVITE_DEFAULT_STUDENT_ID);
  });
});
