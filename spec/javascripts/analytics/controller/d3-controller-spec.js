describe('D3 Analytics Controller', function(){
  var controller,
      DispatcherUtil;

  beforeEach(function(){
    // DEPENDENCIES
    controller = AKUMAI.analytics.controller.D3Controller();
  });

  describe('controller', function(){
    it("to be defined", function() {
      expect(controller).toBeDefined();
    });

    it("should be a singleton", function() {
      var controller2 = AKUMAI.analytics.controller.D3Controller();
      expect(controller === controller2).toBeTruthy();
    });
  });

  describe('instance methods', function(){
    describe('draw method', function(){
      it("to be defined", function() {
        expect(controller.draw).toBeDefined();
      });
    });

    describe('init method', function(){
      it("to be defined", function() {
        expect(controller.init).toBeDefined();
      });
    });
  });
});