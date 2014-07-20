describe('Test module aku.analytics', function() {
  describe('factoryAnalytics', function() {
    var $httpBackend, factory;
    beforeEach(function() {
      module('aku.analytics');
    });

    beforeEach(inject(function($injector){
      $httpBackend = $injector.get('$httpBackend');
      $httpBackend.when('GET', 'analytics/index_helper').respond(
        [{"data":"A",
          "date":"2014-07-18T04:50:46.000Z",
          "id":109,
          "course_name":"algebra",
          "student_id":"A002"},
        {"data":"C",
          "date":"2014-07-18T04:50:46.000Z",
          "id":108,
          "course_name":"trigonometry",
          "student_id":"A001"}]
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