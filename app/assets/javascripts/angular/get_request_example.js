var phonecatApp = angular.module('invitationsUser', []);
phonecatApp.controller('invitationsCtrl', function ($scope, $http){
  $http.get('invitations/index_helper').success(function(data){
    $scope.invitations = data;
  });

  $scope.orderProp = 'created_at';
})
