var createDS3Controller = function(d3_instance){
  var controller = {},
      dataset = {},
      d3 = d3_instance;

  controller.setDataset = function(newDataset){
    dataset = newDataset;
  };

  controller.draw = function(){
    var dataset = [ 5, 10, 15, 20, 25 ];
    d3.select("#visual").selectAll("p")
      .data(dataset)
      .enter()
      .append("p")
      .text(function(d){return "The data is: " + d;});
  };
  
  return controller;
};