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
// This is a manifest file that'll be compiled into invites.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

;
