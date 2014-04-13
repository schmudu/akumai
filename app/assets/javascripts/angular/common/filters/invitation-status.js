angular.module('invitationsStatus', []).filter('filterInvitationsStatus', function(){
  return function(input){
    if(input == 0)
      return "Created";
    else if(input == 1)
      return "Pending Edits";
    else if(input == 2)
      return "Sent";
  }
});

/*
var thisModule = angular.module('invitationsStatus', []);
thisModule.
*/