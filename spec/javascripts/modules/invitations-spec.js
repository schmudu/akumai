describe('Test module aku.invitations', function() {
  describe('factoryInvitations', function() {
    var $httpBackend, factory;
    beforeEach(function() {
      module('aku.invitations');
    });

    beforeEach(inject(function($injector){
      $httpBackend = $injector.get('$httpBackend');
      $httpBackend.when('GET', 'invitations/index_helper').respond(
       [{"id":2,"created_at":"2014-07-03T14:21:44.000Z","creator_id":1,"program_id":1,"user_level":1,"status":2,"recipient_emails":"schmudu@gmail.com","name":"Test Invitation"},
       {"id":1,"created_at":"2014-06-21T05:12:32.000Z","creator_id":1,"program_id":1,"user_level":0,"status":2,"recipient_emails":"","name":"First Invitation"}]
        );
    }));

    beforeEach(inject(function(factoryInvitations){
      factory = factoryInvitations;
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

  describe('filterInvitationsStatus', function() {
    beforeEach(function() {
      module('aku.invitations');
    });

    it('should map ' + INVITATION_STATUS_CREATED + ' to ' + INVITATION_STATUS_CREATED_LABEL, inject(function($filter) {
      var filter = $filter('filterInvitationsStatus');
      expect(filter(INVITATION_STATUS_CREATED)).toBe(INVITATION_STATUS_CREATED_LABEL);
    }));

    it('should map ' + INVITATION_STATUS_PENDING + ' to ' + INVITATION_STATUS_PENDING_LABEL, inject(function($filter) {
      var filter = $filter('filterInvitationsStatus');
      expect(filter(INVITATION_STATUS_PENDING)).toBe(INVITATION_STATUS_PENDING_LABEL);
    }));

    it('should map ' + INVITATION_STATUS_SENT + ' to ' + INVITATION_STATUS_SENT_LABEL, inject(function($filter) {
      var filter = $filter('filterInvitationsStatus');
      expect(filter(INVITATION_STATUS_SENT)).toBe(INVITATION_STATUS_SENT_LABEL);
    }));
  }); 
});