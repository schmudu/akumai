AKUMAI.namespace('AKUMAI.analytics.model.D3Model');

AKUMAI.analytics.model.D3Model = function(){
  var dataset,
      dateMax = null,
      dateMin = null,
      that = {};

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
                .entries(dataset);
                //.entries(d3Controller.getDataset());

  };

  // PUBLIC METHODS
  that.getDataset = function(){
    return dataset;
  };

  that.getDateMax = function(){
    return dateMax;
  };

  that.getDateMin = function(){
    return dateMin;
  };

  that.setDataset = function(new_dataset){
    dataset = new_dataset;

    prepareDataset();
  };

  return that;
};