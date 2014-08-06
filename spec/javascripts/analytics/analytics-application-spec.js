describe('Analytics Application', function(){
  var app;
  beforeEach(function(){
    app = AKUMAI.analytics.Application;
  });

  describe('app', function(){
    it("to be defined", function() {
      expect(app).toBeDefined();
    });
  });

  /*
  describe('instance methods', function(){
    describe('getDataset method', function(){
      it("should return same value as 'setDataset()'", function() {
        var fakeDataset = [{"data":"D","datestring":"2010-05-19","id":185,"course_name":"algebra","student_id":"A003"}];
        controller.setDataset(fakeDataset);
        var testDataset = controller.getDataset();
        expect(fakeDataset).toBeDefined();
        //expect(testDataset[0].date).toBeDefined(testDataset);
      });
    });

    describe('setDataset method', function(){
      it("should respond", function() {
        var fakeDataset = [];
        spyOn(controller, 'setDataset').and.callThrough();
        controller.setDataset(fakeDataset);
        expect(controller.setDataset).toHaveBeenCalled();
      });
    });

    describe('prepareDataset method', function(){
      it("should call 'prepareDataset()' method after setDataset has been called", function() {
        pending();
      });
    });
  });
  */
});