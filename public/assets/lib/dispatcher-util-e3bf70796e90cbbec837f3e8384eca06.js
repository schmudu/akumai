// ==== Requirements:
// * requires namespace.js file which defines namespaces for objects 
// * (see Javascript Patterns book for details)


// ==== Usage
// var Util = AKUMAI.lib.DispatcherUtil();    // create util
// var wife = {};                             // create subject
// Util.makeDispatcher(wife);                 // copy subject privileges to object

// make an observer
// var husband = { playGolf: function(){ console.log("I'm playing golf.")}};

// wife.register(husband);                    // register observer with subject
// wife.notifyObservers();                    // notify observers
// wife.notifyObservers("special_condition"); // [optional - observers must register for condition]
AKUMAI.namespace('AKUMAI.lib.DispatcherUtil');

AKUMAI.lib.DispatcherUtil = function(){
  var that = {};
  var dispatcher = {
    observers: {
      any: []     // event type: subscribers
    },
    register: function(fn, eventType){
      eventType = eventType || 'any';
      if (typeof this.observers[eventType] === "undefined"){
        this.observers[eventType] = [];
      }
      this.observers[eventType].push(fn);
    },
    unregister: function(fn, type){
      //this.notifyObservers('unregister', fn, type);
      var eventType = type || 'any',
          observers = this.observers[eventType],
          i,
          max = observers.length;

      for (i=0; i < max; i+=1){
        if (observers[i] === fn){
          observers.splice(i, 1);
        }
      }
    },
    notifyObservers: function(type){
      var eventType = type || 'any',
          observers = this.observers[eventType],
          i,
          max;

      if (observers !== undefined){
        max = observers.length;
        for (i=0; i < max; i+=1){
          // call all observers
          observers[i].call();
        }
      }
    }
  };

  that.makeDispatcher = function(o){
    var i;
    for (i in dispatcher){
      if (dispatcher.hasOwnProperty(i) && typeof dispatcher[i] === "function"){
        o[i] = dispatcher[i];
      }
    }

    o.observers = {any: []};
  };

  return that;
};
