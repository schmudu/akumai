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
