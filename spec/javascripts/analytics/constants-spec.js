describe('Analytics Constants', function(){
  var constants;
  beforeEach(function(){
    constants = AKUMAI.analytics.Constants();
  });

  describe('test AKUMAI.analytics.constants', function(){
    it("constants should be defined", function() {
      expect(constants).toBeDefined();
    });

    it("width should be defined", function() {
      expect(constants.SVG_HEIGHT).toBeDefined();
    });
  });
});