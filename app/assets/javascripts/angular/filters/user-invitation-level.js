angular.module('invitationsUserLevel', []).filter('filterInvitationsUserLevel', function(){
  return function(input){
    if(input == 1){
      return "match!";
    }
    else{
      return "no match!";
    }
  }

});
