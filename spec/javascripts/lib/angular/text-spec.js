describe('Test module aku.lib.text', function() {
  describe('capitalize', function() {
    var $filter, filter;
    beforeEach(function() {
      //module('aku.lib.text');
      module('aku.lib.text');
      inject(function($injector) {
          $filter = $injector.get('$filter');
          filter = $filter('capitalize');
      });
    });

    it('should capitalize first letter', function(){
      expect(filter('abraham')).toBe('Abraham');
    });
  });
});