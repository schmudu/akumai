AKUMAI.namespace('AKUMAI.analytics.controller.D3Controller');

AKUMAI.analytics.controller.D3Controller = function(){
  // DEPENDENCIES
  var Constants = AKUMAI.analytics.Constants,
      d3model = AKUMAI.analytics.model.D3Model();

  // PRIVATE VARIABLES
  var d3,
      that = {};

  // PRIVATE METHODS

  // PUBLIC METHODS
  that.draw = function(){
    var currentDataset,
        height = Constants.SVG_HEIGHT,
        lineFunction,
        lineGraph,
        svg,
        width = Constants.SVG_WIDTH,
        xScale,
        yScale;

    xScale = d3.time.scale()
              .domain([d3model.getDateMin(), d3model.getDateMax()])
              .range([0, width]);

    yScale = d3.scale.ordinal()
              .domain(['A', 'B', 'C', 'D', 'F'])
              .rangeRoundBands([height, 0], 0.2);

    svg = d3.select("#visual").append("svg")
            .attr("width", width)
            .attr("height", height);

    lineFunction = d3.svg.line()
                    .x(function(d){ return xScale(d.date); })
                    .y(function(d){ return yScale(d.data); })
                    .interpolate("linear");


    currentDataset = d3model.getDataset();

    lineGraph = svg.append("path")
                   .attr("d", lineFunction(currentDataset[0].values[0].values))
                   .attr("stroke", "blue")
                   .attr("fill", "none")
                   .attr("stroke-width", 2);

    svg.selectAll("circle")
       .data(currentDataset[0].values[0].values)
       .enter()
       .append("circle")
       .attr("stroke", "red")
       .attr("fill", "none")
       .attr("cx", function(d){ return xScale(d.date); })
       .attr("cy", function(d){ return yScale(d.data); })
       .attr("r", 5);

    xAxis = d3.svg.axis()
              .scale(xScale)
              .orient("bottom");

    svg.append("g")
       .call(xAxis);
  };

  that.init = function(d3_instance){
    d3 = d3_instance;
    // register as listener
    d3model.register(that.draw,
        Constants.EVENT_D3_MODEL_FINISHED_UPDATING_DATASET);
  };

  // define as singleton
  AKUMAI.analytics.controller.D3Controller = function(){
    return that;
  };
  return that;
};