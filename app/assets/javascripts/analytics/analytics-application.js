AKUMAI.namespace('AKUMAI.analytics.Application');

AKUMAI.analytics.Application = function(d3_instance){
  // Dependencies
  var model = AKUMAI.analytics.model.D3Model(),
      constants = AKUMAI.analytics.Constants();

  // PRIVATE VARIABLES
  var d3 = d3_instance,
      height = constants.SVG_HEIGHT,
      that = {},
      width = constants.SVG_WIDTH;

  // PRIVATE METHODS


  // PUBLIC METHODS
  that.draw = function(){
        // verify that prepareDataset() is called first
    var currentDataset,
        lineFunction,
        lineGraph,
        svg,
        xScale,
        yScale;

    xScale = d3.time.scale()
              .domain([model.getDateMin(), model.getDateMax()])
              .range([0, width]);

    yScale = d3.scale.ordinal()
              .domain(['A', 'B', 'C', 'D', 'F'])
              .rangeRoundBands([height, 0], 0.2);

    /*d3.select("#visual").selectAll("p")
      .data(dataset)
      .enter()
      .append("p")
      .text(function(d){return "The data is: " + d[0].values;});*/
    svg = d3.select("#visual").append("svg")
            .attr("width", width)
            .attr("height", height);

    lineFunction = d3.svg.line()
                    .x(function(d){ return xScale(d.date); })
                    .y(function(d){ return yScale(d.data); })
                    .interpolate("linear");


    currentDataset = model.getDataset();

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
    model.setDataset(new_dataset);
  };

  return that;
};