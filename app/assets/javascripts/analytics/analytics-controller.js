var createDS3Controller = function(d3_instance){
  var controller = {},
      dataset = {},
      d3 = d3_instance,
      dateMax = null,
      dateMin = null;

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
    d3.select("#visual").selectAll("p")
      .data(dataset)
      .enter()
      .append("p")
      .text(function(d){return "The data is: " + d["data"];});
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