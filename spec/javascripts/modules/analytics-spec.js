describe('Test module aku.analytics.factories', function() {
  describe('factoryAnalytics', function() {
    var $httpBackend, factory;
    beforeEach(function() {
      module('aku.analytics.factories');
    });

    beforeEach(inject(function($injector){
      $httpBackend = $injector.get('$httpBackend');
      $httpBackend.when('GET', '/analytics/index_helper').respond(
        [{"data":"A",
          "datestring":"2010-05-19",
          "id":109,
          "course_name":"algebra",
          "student_id":"A002"},
        {"data":"D",
          "datestring":"2010-05-19",
          "id":185,
          "course_name":"algebra",
          "student_id":"A003"}]
        );
    }));

    beforeEach(inject(function(factoryAnalytics){
      factory = factoryAnalytics;
    }));

    afterEach(function(){
      $httpBackend.verifyNoOutstandingExpectation();
      $httpBackend.verifyNoOutstandingRequest();
    });

    it('should return information', function(){
      var returnData;
      factory.get(function(data){
        returnData = data;
      });
      $httpBackend.flush();
      expect(returnData).toBeDefined();
    });
  });
});