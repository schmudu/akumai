angular.module('analyticsIndex', ['aku.analytics'])
.controller('analyticsCtrl', ['$scope', '$http', 'factoryAnalytics',
  function ($scope, $http, factoryAnalytics){

    console.log("running controller.");
  // retrieve data and populate
  factoryAnalytics.get(function(data){
    app.init(data);
  });
}]);
