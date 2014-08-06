describe('Analytics Application', function(){
  var app;
  beforeEach(function(){
    app = AKUMAI.analytics.Application();
  });

  describe('app', function(){
    it("to be defined", function() {
      expect(app).toBeDefined();
    });
  });

  describe('init method', function(){
    it("to be defined", function() {
      expect(app.init).toBeDefined();
    });
  });

  describe('draw method', function(){
    it("to be defined", function() {
      expect(app.draw).toBeDefined();
    });
  });
});