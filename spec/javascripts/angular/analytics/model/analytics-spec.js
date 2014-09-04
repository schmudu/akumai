describe('Test module aku.analytics.model', function() {
  describe('factoryAnalytics', function() {
    var $httpBackend, factory;
    beforeEach(function() {
      module('aku.analytics.model');
    });

    beforeEach(inject(function($injector){
      $httpBackend = $injector.get('$httpBackend');

      // CORE_COURSES
      $httpBackend.when('GET', '/analytics/core_courses').respond(
        [{"id":"1",
          "name":"algebra"},
        {"id":"2",
          "name":"trigonometry"}]
        );

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

    describe('method "core_courses"', function (){
      it('should return information', function(){
        var returnData;
        factory.getCoreCourses(function(data){
          returnData = data;
        });
        $httpBackend.flush();
        expect(returnData).toBeDefined();
      });
    });

    describe('method "getData()"', function (){
      it('should return information', function(){
        var returnData;
        factory.getData(function(data){
          returnData = data;
        });
        $httpBackend.flush();
        expect(returnData).toBeDefined();
      });
    });

    describe('method "getStudents()"', function (){
      it('should return information', function(){
        var returnData;
        factory.getStudents(function(data){
          returnData = data;
        });
        $httpBackend.flush();
        expect(returnData).toBeDefined();
      });
    });
  });
});