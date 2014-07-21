angular.module('analyticsIndex', ['aku.analytics'])
.controller('analyticsCtrl', ['$scope', '$http', 'factoryAnalytics',
  function ($scope, $http, factoryAnalytics){

  // retrieve data and populate
  factoryAnalytics.get(function(data){
    // set dataset for D3
    this.dataset = data;
  });
}]);
