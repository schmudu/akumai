var moduleAkuAnalytics = angular.module('aku.analytics.model', []);

// ====FACTORIES
moduleAkuAnalytics.factory('factoryAnalytics',['$http',function($http){
  return {
    get: function(callback){
      $http.get('/analytics/student_data').success(function(data){
        callback(data);
      });
    }
  };
}]);
