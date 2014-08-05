describe('Analytics Constants', function(){
  var constants;
  beforeEach(function(){
    constants = AKUMAI.analytics.constants;
  });

  describe('test AKUMAI.analytics.constants', function(){
    it("constants should be defined", function() {
      expect(constants).toBeDefined();
    });

    it("width should be defined", function() {
      expect(constants.width).toEqual(200);
    });
  });
});