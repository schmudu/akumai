var createDS3Controller = function(){
  var controller = {},
      dataset = {};

  controller.setDataset = function(newDataset){
    dataset = newDataset;
  };
  
  return controller;
};