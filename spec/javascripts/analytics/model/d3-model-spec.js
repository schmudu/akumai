describe('Analytics Model', function(){
  var model,
      DispatcherUtil;
  beforeEach(function(){
    // DEPENDENCIES
    DispatcherUtil = AKUMAI.lib.DispatcherUtil();
    model = AKUMAI.analytics.model.D3Model();
  });

  describe('model', function(){
    it("to be defined", function() {
      expect(model).toBeDefined();
    });
  });

  describe('instance methods', function(){
    describe('setDataset method', function(){
      it("should respond", function() {
        var fakeDataset = [];
        spyOn(model, 'setDataset').and.callThrough();
        
        // make model dispatcher, dependency for observer pattern
        DispatcherUtil.makeDispatcher(model);

        model.setDataset.call(model, fakeDataset);
        expect(model.setDataset).toHaveBeenCalled();
      });
    });

    describe('getDataset method', function(){
      it("should be defined", function() {
        spyOn(model, 'getDataset').and.callThrough();
        model.getDataset();
        expect(model.getDataset).toHaveBeenCalled();
      });
    });
  });
});