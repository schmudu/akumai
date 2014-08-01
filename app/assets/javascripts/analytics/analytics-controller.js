var createDS3Controller = function(d3_instance){
  var controller = {},
      dataset = {},
      d3 = d3_instance,
      dateMax = null,
      dateMin = null,
      height = 150,
      width = 300;

  // PUBLIC
  controller.getDataset = function(){
    return dataset;
  };

  controller.getDateMax = function(){
    return dateMax;
  };

  controller.getDateMin = function(){
    return dateMin;
  };

  controller.setDataset = function(newDataset){
    dataset = newDataset;

    prepareDataset();
  };

  controller.draw = function(){
    // verify that prepareDataset() is called first
    var currentDataset,
        lineFunction,
        lineGraph,
        svg,
        xScale,
        yScale;

    xScale = d3.time.scale()
              .domain([dateMin, dateMax])
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
            .attr("width", 200)
            .attr("height", 200);

    lineFunction = d3.svg.line()
                    .x(function(d){ return xScale(d.date); })
                    .y(function(d){ return yScale(d.data); })
                    .interpolate("linear");


    currentDataset = this.getDataset();

    lineGraph = svg.append("path")
                   .attr("d", lineFunction(currentDataset[0].values[0].values))
                   .attr("stroke", "blue")
                   .attr("fill", "none")
                   .attr("stroke-width", 2);

    svg.selectAll("circle")
       .data(this.getDataset()[0].values[0].values)
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


  // PRIVATE METHODS
  var prepareDataset = function(){
    prepareDate();
    getMinMaxDates();
    prepareNest();
  };

  var getMinMaxDates = function(){
    // TODO: this only works by looking at ALL of the data.  what
    // if the user only looks at a slice of the data. Need to only search 
    // through a subset
    // after preparing nest, iterate through items and find min max dates
    dataset.forEach(function(element, index, array){
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
  };

  var prepareDate = function(){
    dataset.forEach(function(element, index, array){
      element.date = new Date(element.datestring);
    });
  };

  var prepareNest = function(){
    // nest data as
    // dataset > students > classes
    dataset = d3.nest()
                .key(function(d){ return d.student_id; })
                .key(function(d){ return d.course_name; })
                .entries(d3Controller.getDataset());

  };

  
  return controller;
};