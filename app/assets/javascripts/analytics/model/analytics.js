var moduleAkuAnalytics = angular.module('aku.analytics.model', []);

// ====FACTORIES
moduleAkuAnalytics.factory('factoryAnalytics',['$http',function($http){
  return {
    getData: function(callback){
      $http.get('/analytics/student_data').success(function(data){
        callback(data);
      });
    },
    getStudents: function(callback){
      $http.get('/analytics/students').success(function(data){
        callback(data);
      });
    }
  };
}]);
