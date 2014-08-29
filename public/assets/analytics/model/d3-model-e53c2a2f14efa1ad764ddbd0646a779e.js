AKUMAI.namespace('AKUMAI.analytics.model.D3Model');

AKUMAI.analytics.model.D3Model = function(){
  // DEPENDENCIES
  var Constants = AKUMAI.analytics.Constants,
      DispatcherUtil = AKUMAI.lib.DispatcherUtil();

  var dataset,
      dateMax = null,
      dateMin = null,
      that = {};

  // register as dispatcher
  DispatcherUtil.makeDispatcher(that);

  // PRIVATE METHODS
  var prepareDataset = function(){
    prepareDate();
    getMinMaxDates();
    prepareNest();
    //this.notifyObservers(Constants.EVENT_D3_MODEL_FINISHED_UPDATING_DATASET);
    that.notifyObservers(Constants.EVENT_D3_MODEL_FINISHED_UPDATING_DATASET);
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
                .entries(that.getDataset());
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

  that.init = function(new_dataset){
    //this.setDataset.call(this, new_dataset);
    that.setDataset(new_dataset);
  };

  that.setDataset = function(new_dataset){
    dataset = new_dataset;

    prepareDataset.call(this);
  };

  // define as singleton
  AKUMAI.analytics.model.D3Model = function(){
    return that;
  };
  return that;
};
