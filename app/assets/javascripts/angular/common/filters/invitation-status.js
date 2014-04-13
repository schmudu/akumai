var thisModule = angular.module('invitationsStatus', []);
thisModule.filter('filterInvitationsStatus', function(){
  return function(input){
    if(input == 0)
      return "Created";
    else if(input == 1)
      return "Pending Edits";
    else if(input == 2)
      return "Sent";
  }
});

//var thisModule = angular.module('invitationsStatus', []);
thisModule.filter('filterInvitationsCheckbox', function(){
  return function(invitations, status){
/*
    return invitations.filter(function(invitation){
      //return invitation.status == 2;
      return true;
    });
*/
    //alert("eq?" + invitations);

    if(status == true)
      // write method here to filter array
    else
      return invitations;
  };
});
