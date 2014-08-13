describe('Test module aku.common.color', function() {
  var factory;

  beforeEach(function() {
    module('aku.common.color');
  });

  beforeEach(inject(function(factoryColor){
    factory = factoryColor;
  }));

  describe('factoryColor', function() {
    it('should return information', function(){
      var color;
      color = factory.getColor('line', 3);
      expect(color).toBeDefined();
    });
  });
});