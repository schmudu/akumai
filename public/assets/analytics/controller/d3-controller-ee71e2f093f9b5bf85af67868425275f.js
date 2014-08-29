AKUMAI.namespace('AKUMAI.analytics.controller.D3Controller');

AKUMAI.analytics.controller.D3Controller = function(){
  // DEPENDENCIES
  var Constants = AKUMAI.analytics.Constants,
      colorManager = AKUMAI.analytics.model.D3ColorManager(),
      d3Model = AKUMAI.analytics.model.D3Model();

  // PRIVATE VARIABLES
  var d3,
      that = {},

  // PRIVATE METHODS
  createLineFunction = function(){
    lineFunction = d3.svg.line()
                    .x(function(d){ return xScale(d.date); })
                    .y(function(d){ return yScale(d.data); })
                    .interpolate("linear");

    return lineFunction;
  },
  createSVG = function(){
    svg = d3.select("#visual").append("svg")
            .attr("width", getWidth())
            .attr("height", getHeight());
    return svg;
  },
  createXAxis = function(){
    xAxis = d3.svg.axis()
              .scale(xScale)
              .orient("bottom");
    return xAxis;
  },
  createXScale = function(){
    xScale = d3.time.scale()
              .domain([d3Model.getDateMin(), d3Model.getDateMax()])
              .range([0, getWidth()]);
    return xScale;
  },
  createYScale = function(){
    yScale = d3.scale.ordinal()
              .domain(['A', 'B', 'C', 'D', 'F'])
              .rangeRoundBands([getHeight(), 0], 0.2);
    return yScale;
  },
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
  drawXAxis = function(svg){
    svg.append("g")
       .attr("transform", "translate(0," + (getHeight() - Constants.SVG_PADDING) + ")")
       .call(xAxis);
  },
  getHeight = function(){
    return Constants.SVG_HEIGHT;
  },
  getWidth = function(){
    return Constants.SVG_WIDTH;
  };


  // PUBLIC METHODS
  that.draw = function(){
    var lineFunction,
        svg,
        xScale,
        yScale;

    // create scales
    xScale = createXScale();
    yScale = createYScale();

    // create svg element
    svg = createSVG();

    // draw graphs
    lineFunction = createLineFunction();
    drawLineGraph(svg, lineFunction);
    drawCircleNodes(xScale, yScale);

    // axes
    xAxis = createXAxis();
    drawXAxis(svg);
  };

  that.init = function(d3_instance){
    d3 = d3_instance;
    // register as listener
    d3Model.register(that.draw,
        Constants.EVENT_D3_MODEL_FINISHED_UPDATING_DATASET);
  };

  // define as singleton
  AKUMAI.analytics.controller.D3Controller = function(){
    return that;
  };
  return that;
};
