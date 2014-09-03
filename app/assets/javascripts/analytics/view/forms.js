angular.module('aku.analytics.view.forms', [])
.directive('akuStudentCheckbox', function(){
  var link = function(scope, elem, attrs){
  };
  return {
    link: link,
    restrict: 'E',
    scope: {
      student: "=",
      onClick: "&"
    },
    templateUrl: '/assets/templates/student-checkbox.html'
  };
});
