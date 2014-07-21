describe('Analytics Controller', function(){
  describe('constructor', function(){
    it("to be defined upon calling 'createDS3Controller()' method", function() {
      var controller = createDS3Controller();
      expect(controller).toBeDefined();
    });
  });

  describe('instance methods', function(){
    it("should respond to 'setDataset()' method", function() {
      var controller = createDS3Controller();
      var fakeDataset = [];
      spyOn(controller, 'setDataset').and.callThrough();
      controller.setDataset(fakeDataset);
      expect(controller.setDataset).toHaveBeenCalled();
    });
  });
});