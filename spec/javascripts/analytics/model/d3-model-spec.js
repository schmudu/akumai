describe('Analytics Model', function(){
  var model;
  beforeEach(function(){
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
        model.setDataset(fakeDataset);
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