var datePickerApp=angular.module("datePickerApp",["ui.bootstrap"]);datePickerApp.controller("DatepickerDemoCtrl",function(t){t.today=function(){t.dt=new Date},t.today(),t.showWeeks=!0,t.toggleWeeks=function(){t.showWeeks=!t.showWeeks},t.clear=function(){t.dt=null},t.disabled=function(t,e){return"day"===e&&(0===t.getDay()||6===t.getDay())},t.toggleMin=function(){t.minDate=t.minDate?null:new Date},t.toggleMin(),t.open=function(e){e.preventDefault(),e.stopPropagation(),t.opened=!0},t.dateOptions={"year-format":"'yy'","starting-day":1},t.formats=["dd-MMMM-yyyy","yyyy/MM/dd","shortDate"],t.format=t.formats[0]});