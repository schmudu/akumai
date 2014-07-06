angular.module('invitationsUserLevel', []).filter('filterInvitationsUserLevel', function(){
  return function(input){
    if(input === LEVEL_ROLE_ADMIN)
      return LEVEL_ROLE_ADMIN_STRING;
    else if(input === LEVEL_ROLE_STAFF)
      return LEVEL_ROLE_STAFF_STRING;
    else if(input === LEVEL_ROLE_STUDENT)
      return LEVEL_ROLE_STUDENT_STRING;
  };
});
