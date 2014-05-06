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
    if(status == true){
      results = [];     // return value

      // iterate and return sent invitations
      for (var i = 0; i < invitations.length; i++){
        if (invitations[i].status == 2)
          results.push(invitations[i]);
      };
      return results;
    }
    else
      return invitations;
  };
});
