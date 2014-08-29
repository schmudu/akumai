angular.module('aku.analytics.view.forms', [])
.directive('akuStudentCheckbox', function(){
  return {
    restrict: 'E',
    scope: {
      data: "="
    },
    templateUrl: '/assets/templates/student-checkbox.html'
  };
});
