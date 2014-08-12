AKUMAI.namespace('AKUMAI.analytics.model.D3ColorManager');

AKUMAI.analytics.model.D3ColorManager = function(){
  // DEPENDENCIES
  var Constants = AKUMAI.analytics.Constants;

  var d3,
      that = {},

  // PRIVATE METHODS
  getLineColor = function(id){
    // line colors
    // colorlovours.com - The_First_Raindrop
    var colors = [
      d3.rgb(232, 243, 248),
      d3.rgb(219, 230, 236),
      d3.rgb(194, 203, 206),
      d3.rgb(164, 188, 194),
      d3.rgb(129, 168, 184)
    ];
    return colors[id % colors.length];
  },
  getPointColor = function(id){
    // line colors
    // colorlovours.com - fire_withing
    var colors = [
      d3.rgb(239, 172, 65),
      d3.rgb(222, 133, 49),
      d3.rgb(179,  41, 0),
      d3.rgb(108,  19, 5),
      d3.rgb(51,   10, 4)
    ];
    return colors[id % colors.length];
  };


  // PUBLIC METHODS
  that.getColor = function(elementType, id){
    if(elementType == "line"){
      return getLineColor(id);
    }
    else if(elementType == "point"){
      return getPointColor(id);
    }
  };

  that.init = function(d3_instance){
    d3 = d3_instance;
  };

  // define as singleton
  AKUMAI.analytics.model.D3ColorManager = function(){
    return that;
  };
  return that;
};