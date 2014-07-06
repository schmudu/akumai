describe('Test module Invitations', function() {
  describe('filterInvitationsStatus', function() {
    beforeEach(function() {
      module('invitationsStatus'); 
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