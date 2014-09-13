function setFormTextFocus(input_id, default_entry){
  var current_entry = $(input_id).val();

  if(current_entry === default_entry){
    // default entry, set class
    $(input_id).val('');
    $(input_id).removeClass("form_default_entry");
  }
}

function setFormTextBlur(input_id, default_entry){
  var current_entry = $(input_id).val();

  if((current_entry === default_entry) || (current_entry === '')){
    // default entry, set class
    $(input_id).val(default_entry);
    $(input_id).addClass("form_default_entry");
  }
  else{
    $(input_id).removeClass("form_default_entry");
  }
}

function uncheckRadioButton(input_id){
  if($(input_id).is(':checked') === true)
    $(input_id).prop('checked', false);
}
;
// This is a manifest file that'll be compiled into forms.js, which will include all the files
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
