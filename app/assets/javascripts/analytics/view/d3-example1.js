angular.module('d3AngularApp', ['d3', 'aku.analytics.model'])
.directive('d3Bars', ['$window', '$timeout', 'd3Service',
  function($window, $timeout, d3Service) {
    return {
      restrict: 'A',
      scope: {
        data: '=',
        label: '@',
        onClick: '&'
      },
      link: function(scope, ele, attrs) {
        d3Service.d3().then(function(d3) {
          // PRIVATE VARIABLES
          var renderTimeout;
          var margin = parseInt(attrs.margin) || 20,
              barHeight = parseInt(attrs.barHeight) || 20,
              //barPadding = parseInt(attrs.barPadding) || 5;
              dateMax,
              dateMin,
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
            xAxis = d3.svg.axis()
                      .scale(xScale)
                      .orient("bottom");
            return xAxis;
          },
          createXScale = function(){
            xScale = d3.time.scale()
                      .domain([dateMin, dateMax])
                      .range([0, getWidth()]);
            return xScale;
          },
          createYScale = function(){
            yScale = d3.scale.ordinal()
                      .domain(['A', 'B', 'C', 'D', 'F'])
                      .rangeRoundBands([getHeight(), 0], 0.2);
            return yScale;
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
          /*
          drawCircleNodes = function(xScale, yScale){
            svg.selectAll("circle")
               .data(d3Model.getDataset()[0].values[0].values)
               .enter()
               .append("circle")
               .attr("stroke", colorManager.getColor("point", 1))
               .attr("fill", "none")
               .attr("cx", function(d){ return xScale(d.date); })
               .attr("cy", function(d){ return yScale(d.data); })
               .attr("r", 5);

          },
          drawLineGraph = function(svg, lineFunction){
            var dataElements = d3Model.getDataset();
            svg.append("path")
               .attr("d", lineFunction(d3Model.getDataset()[0].values[0].values))
               .attr("stroke", colorManager.getColor("line", 1))
               .attr("fill", "none")
               .attr("stroke-width", 2);
          },
          */
          drawXAxis = function(svg){
            svg.append("g")
               .attr("transform", "translate(0," + (getHeight() - Constants.SVG_PADDING) + ")")
               .call(xAxis);
          },
          getHeight = function(){
            return scope.data.length * (barHeight + padding);
          },
          getWidth = function(){
            return d3.select(ele[0])[0][0].offsetWidth - margin;
          };

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

            // prepare data
            preparedDataset = data;
            prepareDate();
            getMinMaxDates();
            prepareNest();

            if (renderTimeout) clearTimeout(renderTimeout);

            renderTimeout = $timeout(function() {
              /*
              var width = d3.select(ele[0])[0][0].offsetWidth - margin,
                  height = scope.data.length * (barHeight + barPadding),
                  color = d3.scale.category20(),
                  xScale = d3.scale.linear()
                    .domain([0, d3.max(data, function(d) {
                      return d.score;
                    })])
                    .range([0, width]);

              svg.attr('height', height);

              svg.selectAll('rect')
                .data(data)
                .enter()
                  .append('rect')
                  .on('click', function(d,i) {
                    return scope.onClick({item: d});
                  })
                  .attr('height', barHeight)
                  .attr('width', 140)
                  .attr('x', Math.round(margin/2))
                  .attr('y', function(d,i) {
                    return i * (barHeight + barPadding);
                  })
                  .attr('fill', function(d) {
                    return color(d.score);
                  })
                  .transition()
                    .duration(1000)
                    .attr('width', function(d) {
                      return xScale(d.score);
                    });
              svg.selectAll('text')
                .data(data)
                .enter()
                  .append('text')
                  .attr('fill', '#fff')
                  .attr('y', function(d,i) {
                    return i * (barHeight + barPadding) + 15;
                  })
                  .attr('x', 15)
                  .text(function(d) {
                    return d.name + " (scored: " + d.score + ")";
                  });
                */
              console.log("need to draw the data: " + data);
              //var lineFunction = createLineFunction();
              var lineFunction,
                  svg,
                  xScale,
                  yScale;

              // create scales
              xScale = createXScale();
              yScale = createYScale();
            }, 200);
          };
        });
      }};
}])
.controller('MainCtrl', ['factoryAnalytics', '$scope', function(factoryAnalytics, $scope) {
  $scope.testData = factoryAnalytics.get(function(data){
    // set the data after received
    $scope.data = data;
  });
  /*
  $scope.data = [
    {name: 'Ari', score: 10},
    {name: 'Q', score: 90}
    ];*/
}]);