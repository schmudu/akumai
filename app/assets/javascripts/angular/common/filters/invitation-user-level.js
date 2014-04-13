angular.module('invitationsUserLevel', []).filter('filterInvitationsUserLevel', function(){
  return function(input){
    if(input == 2)
      return "Admin";
    else if(input == 1)
      return "Staff";
    else if(input == 0)
      return "Student";
  }
});
