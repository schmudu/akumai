angular.module('analyticsIndex', [])
.controller('analyticsCtrl', ['$scope', '$http', function(){
  $scope.test = function(){
    alert("here i am!");
  };
  /*
  function ($scope, $http, factoryInvitations){

  // retrieve data and populate
  factoryInvitations.get(function(data){
    $scope.invitations = data;
  });

  $scope.orderProp = 'created_at';
  */
}]);
