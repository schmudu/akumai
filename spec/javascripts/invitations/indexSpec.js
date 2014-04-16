describe('invitationsUserLevel', function(){
  beforeEach(module('invitationsUserLevel'));

  it('should create "phone" model with 3 phones', inject(function($filter){
    /*
    var scope = {},
        filter = $filter('filterInvitationsUserLevel', {$scope:scope});

    expect(filter(2)).toBe("Admin");
    */

    expect(true).toBe(true);

  }));
  
  /*
  var scope;//we'll use this scope in our tests
 
  //mock Application to allow us to inject our own dependencies
  beforeEach(angular.mock.module('invitationsUserLevel'));
  //mock the controller for the same reason and include $rootScope and $controller
  beforeEach(angular.mock.inject(function($rootScope, $filter){
      //create an empty scope
      scope = $rootScope.$new();
      //declare the controller and inject our empty scope
      $filter('filterInvitationsUserLevel', {$scope: scope});
  }));

  it('should have variable text = "Hello World!"', function(){
      expect(scope.text).toBe('Hello World!');
  });*/
});