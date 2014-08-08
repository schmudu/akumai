AKUMAI.namespace('AKUMAI.analytics.Application');

AKUMAI.analytics.Application = function(d3_instance){
  // Dependencies
  var d3controller = AKUMAI.analytics.controller.D3Controller(),
      d3model = AKUMAI.analytics.model.D3Model(),
      Constants = AKUMAI.analytics.Constants;
      //DispatcherUtil = AKUMAI.lib.DispatcherUtil();

  // PRIVATE VARIABLES
  var d3 = d3_instance,
      height = Constants.SVG_HEIGHT,
      that = {},
      width = Constants.SVG_WIDTH;

  // PRIVATE METHODS

  // PUBLIC METHODS
  that.draw = function(){
    var currentDataset,
        lineFunction,
        lineGraph,
        svg,
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

  that.init = function(new_dataset){
    d3controller.init();

    /*
    // set listener
    DispatcherUtil.makeDispatcher(d3model);
    d3model.register(that.draw,
        Constants.EVENT_MODEL_FINISHED_PREPARING_DATASET);

    d3model.setDataset.call(d3model, new_dataset);
    */
    // make d3 model a dispatcher
    //DispatcherUtil.makeDispatcher(d3model);
    d3model.init.call(d3model, new_dataset);
  };

  return that;
};