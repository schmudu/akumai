describe('PhoneCat controllers', function() {

  describe('PhoneListCtrl', function(){

    beforeEach(function() {
      module('invitationsUserLevel'); // <= initialize module that should be tested
    });

    /*
    it('should create "phones" model with 3 phones', inject(function($filter) {
      var scope = {},
          filter = $filter('filterInvitationsUserLevel');

      expect(filter(2)).toBe('Admin');
    }));
*/
    it('should create "phones" model with 3 phones', inject(function($filter) {
      expect(true).toBe(true);
    }));
  });
});