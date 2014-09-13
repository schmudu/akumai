angular.module('invitationsIndex', ['aku.users', 'aku.invitations'])
.controller('invitationsCtrl', ['$scope', '$http', 'factoryInvitations', 
  function ($scope, $http, factoryInvitations){

  // retrieve data and populate
  factoryInvitations.get(function(data){
    $scope.invitations = data;
  });

  $scope.orderProp = 'created_at';
}]);
