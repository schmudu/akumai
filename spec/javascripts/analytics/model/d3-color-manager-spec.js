describe('D3 Color Manager', function(){
  var colorManager;

  beforeEach(function(){
    // DEPENDENCIES
    colorManager = AKUMAI.analytics.model.D3ColorManager();
  });

  describe('colorManager', function(){
    it("to be defined", function() {
      expect(colorManager).toBeDefined();
    });

    it("should be a singleton", function() {
      var colorManager2 = AKUMAI.analytics.model.D3ColorManager();
      expect(colorManager === colorManager2).toBeTruthy();
    });
  });

  describe('instance methods', function(){
    describe('getColor method', function(){
      it("to be defined", function() {
        expect(colorManager.getColor).toBeDefined();
      });
    });
  });
});