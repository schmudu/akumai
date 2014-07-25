angular.module('analyticsIndex', ['aku.analytics'])
.controller('analyticsCtrl', ['$scope', '$http', 'factoryAnalytics',
  function ($scope, $http, factoryAnalytics){

    console.log("running controller.");
  // retrieve data and populate
  factoryAnalytics.get(function(data){
    // set dataset for D3
    //this.dataset = data;

    // d3 controller has already been set to variable 'd3Controller'
    // set dataset to d3
    d3Controller.setDataset(data);
    d3Controller.draw();
  });
}]);
