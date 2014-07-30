var createDS3Controller = function(d3_instance){
  var controller = {},
      dataset = {},
      d3 = d3_instance;

  // PUBLIC
  controller.getDataset = function(){
    return dataset;
  };

  controller.setDataset = function(newDataset){
    dataset = newDataset;

    prepareDataset();
  };

  controller.draw = function(){
    // prepare data
    d3.nest()
      .key(function(d){ return d.student_id; })
      .key(function(d){ return d.course_name; })
      .entries(d3Controller.getDataset());

    d3.select("#visual").selectAll("p")
      .data(dataset)
      .enter()
      .append("p")
      .text(function(d){return "The data is: " + d["data"];});
  };


  // PRIVATE METHODS
  var prepareDataset = function(){
    prepareDate();
  };

  var prepareDate = function(){
    dataset.forEach(function(element, index, array){
      element.date = new Date(element.datestring);
    });
  };

  
  return controller;
};