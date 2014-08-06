describe('Analytics Controller', function(){
  var controller;
  beforeEach(function(){
    controller = createDS3Controller(d3);
  });

  describe('constructor', function(){
    it("to be defined upon calling 'createDS3Controller()' method", function() {
      expect(controller).toBeDefined();
    });
  });
});