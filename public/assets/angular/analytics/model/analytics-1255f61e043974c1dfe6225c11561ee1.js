var moduleAkuAnalytics = angular.module('aku.analytics.model', []);

// ====FACTORIES
moduleAkuAnalytics.factory('factoryAnalytics',['$http',function($http){
  return {
    getCoreCourses: function(callback){
      $http.get('/analytics/core_courses').success(function(data){
        var returnObj = {
          allCourses: true,
          list: data
        };

        callback(returnObj);
      });
    },
    getData: function(callback){
      $http.get('/analytics/student_data').success(function(data){
        callback(data);
      });
    },
    getStudents: function(callback){
      $http.get('/analytics/students').success(function(data){
        var returnObj = {
          allStudents: true,
          list: data
        };

        callback(returnObj);
      });
    }
  };
}]);
