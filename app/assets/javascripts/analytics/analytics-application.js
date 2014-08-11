AKUMAI.namespace('AKUMAI.analytics.Application');

AKUMAI.analytics.Application = function(d3_instance){
  // Dependencies
  var d3controller = AKUMAI.analytics.controller.D3Controller(),
      d3model = AKUMAI.analytics.model.D3Model();

  // PRIVATE VARIABLES
  var d3 = d3_instance,
      that = {};

  // PRIVATE METHODS

  // PUBLIC METHODS
  that.init = function(new_dataset){
    d3controller.init(d3);
    d3model.init(new_dataset);
  };

  return that;
};