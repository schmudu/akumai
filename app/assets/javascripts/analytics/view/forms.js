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
    templateUrl: '/assets/templates/student-checkbox.html'
  };
});
