angular.module('analyticsIndex', ['aku.analytics.factories'])
.controller('analyticsCtrl', ['$scope', '$http', 'factoryAnalytics',
  function ($scope, $http, factoryAnalytics){
    // retrieve data and populate
    factoryAnalytics.get.call(this, function(data){
      // initialize app that is on page
      app.init(data);
    });
  }
]);
