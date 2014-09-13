angular.module('aku.analytics.view.forms', [])
.directive('akuStudentCheckbox', function(){
  var link = function(scope, elem, attrs){
  };
  return {
    link: link,
    restrict: 'A',
    scope: {
      student: "=",
      onClick: "&"
    },
    templateUrl: '/templates/student_checkbox'
  };
})
.directive('akuCheckboxCourse', function(){
  var link = function(scope, elem, attrs){
  };
  return {
    link: link,
    restrict: 'A',
    scope: {
      course: "=",
      onClick: "&"
    },
    templateUrl: '/templates/core_course_checkbox'
  };
});
