angular.module('analyticsIndex', ['aku.analytics'])
.controller('analyticsCtrl', ['$scope', '$http', 'factoryAnalytics',
  function ($scope, $http, factoryAnalytics){

    console.log("running analytics controller.");

  // retrieve data and populate
  factoryAnalytics.get(function(data){
    // initialize app that is on page
    app.init(data);
  });
}]);
