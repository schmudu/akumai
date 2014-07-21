var moduleAkuAnalytics = angular.module('aku.analytics', []);

// ====FACTORIES
moduleAkuAnalytics.factory('factoryAnalytics',['$http',function($http){
  return {
    get: function(callback){
      $http.get('analytics/index_helper').success(function(data){
        callback(data);
      });
    }
  };
}]);