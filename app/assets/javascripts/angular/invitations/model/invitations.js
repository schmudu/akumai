var moduleAkuInvitations = angular.module('aku.invitations', []);

// ====FACTORIES
moduleAkuInvitations.factory('factoryInvitations',['$http',function($http){
  return {
    get: function(callback){
      $http.get('invitations/index_helper').success(function(data){
        callback(data);
      });
    }
  };
}]);

// ====FILTERS
moduleAkuInvitations.filter('filterInvitationsStatus', function(){
  return function(input){
    if(input === INVITATION_STATUS_CREATED){
      return INVITATION_STATUS_CREATED_LABEL;
    }
    else if(input === INVITATION_STATUS_PENDING){
      return INVITATION_STATUS_PENDING_LABEL;
    }
    else if(input === INVITATION_STATUS_SENT){
      return INVITATION_STATUS_SENT_LABEL;
    }
  };
});

moduleAkuInvitations.filter('filterInvitationsCheckbox', function(){
  return function(invitations, status){
    if(status === true){
      results = [];     // return value

      // iterate and return sent invitations
      for (var i = 0; i < invitations.length; i++){
        if (invitations[i].status === 2){
          results.push(invitations[i]);
        }
      }
      return results;
    }
    else{
      return invitations;
    }
  };
});
