describe('Test module aku.analytics.model', function() {
  describe('factoryAnalytics', function() {
    var $httpBackend, factory;
    beforeEach(function() {
      module('aku.analytics.model');
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

    it('method "get" should return information', function(){
      var returnData;
      factory.get(function(data){
        returnData = data;
      });
      $httpBackend.flush();
      expect(returnData).toBeDefined();
    });
  });
});