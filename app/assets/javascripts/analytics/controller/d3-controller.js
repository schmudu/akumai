AKUMAI.namespace('AKUMAI.analytics.controller.D3Controller');

AKUMAI.analytics.controller.D3Controller = function(){
  // DEPENDENCIES
  var Constants = AKUMAI.analytics.Constants,
      d3model = AKUMAI.analytics.model.D3Model();

  // PRIVATE VARIABLES
  var that = {};

  // PRIVATE METHODS

  // PUBLIC METHODS
  that.draw = function(){
    console.log("d3 controller needs to draw.");
  };

  that.init = function(){
    console.log("init controller d3");
    d3model.register(that.draw,
        Constants.EVENT_MODEL_FINISHED_PREPARING_DATASET);
  };

  // define as singleton
  AKUMAI.analytics.controller.D3Controller = function(){
    return that;
  };
  return that;
};