describe('Analytics Controller', function(){
  describe('constructor', function(){
    it("to be defined upon calling 'createDS3Controller()' method", function() {
      var controller = createDS3Controller();
      expect(controller).toBeDefined();
    });
  });

  describe('instance methods', function(){
    describe('getDataset method', function(){
      it("should return same value as 'setDataset()'", function() {
        var controller = createDS3Controller();
        var fakeDataset = [{"dateString":"2014-07-18T04:50:46.000Z"}];
        controller.setDataset(fakeDataset);
        var testDataset = controller.getDataset();
        expect(fakeDataset).toEqual(testDataset);
        expect(testDataset[0].date).toBeDefined(testDataset);
      });
    });

    describe('setDataset method', function(){
      it("should respond", function() {
        var controller = createDS3Controller();
        var fakeDataset = [];
        spyOn(controller, 'setDataset').and.callThrough();
        controller.setDataset(fakeDataset);
        expect(controller.setDataset).toHaveBeenCalled();
      });
    });

    describe('prepareDataset method', function(){
      it("should call 'prepareDataset()' method after setDataset has been called", function() {
        pending();
      });
    });
  });
});