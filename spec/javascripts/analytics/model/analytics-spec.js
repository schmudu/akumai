describe('Test module aku.analytics.model', function() {
  describe('factoryAnalytics', function() {
    var $httpBackend, factory;
    beforeEach(function() {
      module('aku.analytics.model');
    });

    beforeEach(inject(function($injector){
      $httpBackend = $injector.get('$httpBackend');

      // STUDENT DATA
      $httpBackend.when('GET', '/analytics/student_data').respond(
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

      // STUDENTS
      $httpBackend.when('GET', '/analytics/students').respond(
        [{"id":"1",
          "student_id":"A002"},
        {"id":"2",
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

    it('method "student_data" should return information', function(){
      var returnData;
      factory.getData(function(data){
        returnData = data;
      });
      $httpBackend.flush();
      expect(returnData).toBeDefined();
    });

    it('method "students" should return information', function(){
      var returnData;
      factory.getStudents(function(data){
        returnData = data;
      });
      $httpBackend.flush();
      expect(returnData).toBeDefined();
    });
  });
});