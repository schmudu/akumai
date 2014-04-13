var invitationsUserModule = angular.module('invitationsUser', ['invitationsUserLevel']);
invitationsUserModule.controller('invitationsCtrl', function ($scope, $http){
  $http.get('invitations/index_helper').success(function(data){
    $scope.invitations = data;
  });

  $scope.orderProp = 'created_at';
})