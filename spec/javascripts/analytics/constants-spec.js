describe('Test module aku.analytics.constants', function() {
  var factory;

  beforeEach(function() {
    module('aku.analytics.constants');
  });

  beforeEach(inject(function(factoryConstants){
    factory = factoryConstants;
  }));

  describe('factoryConstants', function() {
    it('should define constants', function(){
      var constant;
      constant = factory.d3Width;
      expect(constant).toBeDefined();
    });
  });
});