angular.module('analyticsIndex', ['aku.analytics.factories'])
.controller('analyticsCtrl', ['$scope', '$http', 'factoryAnalytics',
  function ($scope, $http, factoryAnalytics){

  // retrieve data and populate
  factoryAnalytics.get(function(data){
    // initialize app that is on page
    app.init(data);
  });
}]);
