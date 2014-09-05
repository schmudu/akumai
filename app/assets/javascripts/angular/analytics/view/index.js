angular.module('aku.analytics.view.index', ['d3', 'aku.analytics.model','aku.analytics.view.forms', 'aku.lib.text'])
.directive('analyticsGraph', ['$window', '$timeout', 'd3Service',
  function($window, $timeout, d3Service) {
    return {
      restrict: 'A',
      scope: {
        courses: '=',
        data: '=',
        label: '@',
        onClick: '&',
        students: '='
      },
      link: function(scope, ele, attrs) {
        d3Service.d3().then(function(d3) {
          // PRIVATE VARIABLES
          var renderTimeout;
          var axisX,
              axisY,
              //margin = parseInt(attrs.margin) || 20,
              barHeight = parseInt(attrs.barHeight) || 20,
              //barPadding = parseInt(attrs.barPadding) || 5;
              color = d3.scale.category20(),
              dateMax = null,
              dateMin = null,
              padding = parseInt(attrs.padding) || 5,
              preparedDataset;

          var svg = d3.select(ele[0])
            .append('svg')
            .style('width', '100%');

          $window.onresize = function() {
            scope.$apply();
          };

          // PRIVATE METHODS
          var createLineFunction = function(){
            lineFunction = d3.svg.line()
                            .x(function(d){ return xScale(d.date); })
                            .y(function(d){ return yScale(d.data); })
                            .interpolate("linear");
            return lineFunction;
          },
          createXAxis = function(){
            var xAxis = d3.svg.axis()
                      .scale(xScale)
                      .orient("bottom");
            return xAxis;
          },
          createYAxis = function(){
            var yAxis = d3.svg.axis()
                      .scale(yScale)
                      .orient("left");
            return yAxis;
          },
          createXScale = function(){
            xScale = d3.time.scale()
                      .domain([dateMin, dateMax])
                      .range([0 - getMargin(), getWidth() - getMargin()]);
            return xScale;
          },
          createYScale = function(){
            yScale = d3.scale.ordinal()
                      .domain(['A', 'B', 'C', 'D', 'F'])
                      .rangeRoundBands([0, getHeight()], 0.2);
            return yScale;
          },
          drawXAxis = function(){
            svg.append("g")
               .attr("transform", "translate(0," + (getHeight() - getMargin()) + ")")
               .call(axisX);
          },
          drawYAxis = function(){
            svg.append("g")
               .attr("transform", "translate(" + getMargin() + ", 0)")
               .call(axisY);
          },
          findCourse = function(formArrayCourses, course_name){
            for (var i=0; i<formArrayCourses.length; i++){
              if (formArrayCourses[i].name === course_name){
                return formArrayCourses[i];
              }
            }
            return null;
          },
          findStudent = function(formArrayStudents, student_id){
            for (var i=0; i<formArrayStudents.length; i++){
              if (formArrayStudents[i].student_id === student_id){
                return formArrayStudents[i];
              }
            }
            return null;
          },
          getMargin = function(){
            return (parseInt(attrs.margin) || 20);
          },
          prepareDate = function(){
            preparedDataset.forEach(function(element, index, array){
              element.date = new Date(element.datestring);
            });
          },
          prepareNest = function(){
            // nest data as
            // dataset > students > classes
            preparedDataset = d3.nest()
                        .key(function(d){ return d.student_id; })
                        .key(function(d){ return d.course_name; })
                        .entries(preparedDataset);
          },
          getMinMaxDates = function(){
            // TODO: this only works by looking at ALL of the data.  what
            // if the user only looks at a slice of the data. Need to only search 
            // through a subset
            // after preparing nest, iterate through items and find min max dates
            preparedDataset.forEach(function(element, index, array){
              // minimum date
              if (dateMin === null){
                dateMin = element.date;
              }
              else{
                if (element.date < dateMin){
                  dateMin = element.date;
                }
              }

              // maximum date
              if (dateMax === null){
                dateMax = element.date;
              }
              else{
                if (element.date > dateMax){
                  dateMax = element.date;
                }
              }
            });
          },
          drawCircleNodes = function(){
            svg.selectAll("circle")
               .data(preparedDataset[0].values[0].values)
               .enter()
               .append("circle")
               .attr("stroke", color(2))
               .attr("fill", "none")
               .attr("cx", function(d){ return xScale(d.date); })
               .attr("cy", function(d){ return yScale(d.data); })
               .attr("r", 5);
          },
          drawLineGraph = function(lineFunction){
            var allStudents = scope.students.allStudents;
            var allCourses = scope.courses.allCourses;
            var students = scope.students.list;
            var courses = scope.courses.list;
            // iterate through first students classes
            for(var studentIndex=0; studentIndex<preparedDataset.length; studentIndex++){
              var currentStudent = preparedDataset[studentIndex];
              //var checkbox_student = scope.students.list.find(findStudent, current_student.key);
              var checkboxStudent = findStudent(students, currentStudent.key);
              // if student is checked then draw this student
              // or if all students need to be drawn
              // TODO: iterating by indices however it doesn't match up with preparedDataset!!
              if((checkboxStudent.checked === true) || (allStudents === true)){
                for(var courseIndex=0; courseIndex<preparedDataset[studentIndex].values.length; courseIndex++){
                  var currentCourse = preparedDataset[studentIndex].values[courseIndex];
                  var checkboxCourse = findCourse(courses, currentCourse.key);

                  if(((checkboxCourse !== null) && (checkboxCourse.checked === true)) ||
                      (allCourses === true)){
                    // draw path
                    svg.append("path")
                       .attr("d", lineFunction(currentCourse.values))
                       .attr("stroke", color(1))
                       .attr("fill", "none")
                       .attr("stroke-width", 2);
                  }
                }
              }
            }
          },
          getHeight = function(){
            //return d3.select(ele[0])[0][0].offsetHeight - getMargin();
            return 200;
          },
          getWidth = function(){
            return d3.select(ele[0])[0][0].offsetWidth - getMargin();
          };

          scope.$on("onApplyChanges", function(){
            scope.render(scope.data);
          });

          scope.$watch(function() {
            return angular.element($window)[0].innerWidth;
          }, function() {
            scope.render(scope.data);
          });

          scope.$watch('data', function(newData) {
            scope.render(newData);
          }, true);

          scope.render = function(data) {
            svg.selectAll('*').remove();

            if (!data) return;

            if (renderTimeout) clearTimeout(renderTimeout);

            renderTimeout = $timeout(function() {
              var lineFunction,
                  svg,
                  xScale,
                  yScale;

              // prepare data
              preparedDataset = data;
              prepareDate();
              getMinMaxDates();
              prepareNest();

              // create scales
              createXScale();
              createYScale();

              // draw graphs
              lineFunction = createLineFunction();
              drawLineGraph(lineFunction);
              drawCircleNodes();

              // axes
              axisX = createXAxis();
              drawXAxis(svg);
              axisY = createYAxis();
              drawYAxis(svg);
            }, 200);
          };
        });
      }};
}])
.controller('mainController', ['factoryAnalytics', '$scope', function(factoryAnalytics, scope) {
  // the apply button was pressed
  scope.onApplyChanges = function(){
    scope.$broadcast("onApplyChanges");
  };

  scope.onClickCourse = function(){
    scope.courses.allCourses = false;
  };

  scope.onClickStudent = function(){
    scope.students.allStudents = false;
  };

  factoryAnalytics.getCoreCourses(function(data){
    // set the data after received
    scope.courses = data;
  });

  factoryAnalytics.getData(function(data){
    // set the data after received
    scope.data = data;
  });

  factoryAnalytics.getStudents(function(data){
    // set the data after received
    scope.students = data;
  });
}]);