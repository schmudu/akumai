describe('Test module Users', function() {
  describe('user level', function() {
    beforeEach(function() {
      module('aku.users'); 
    });

    it('should map ' + LEVEL_ROLE_ADMIN + ' to ' + LEVEL_ROLE_ADMIN_STRING, inject(function($filter) {
      var filter = $filter('filterUserLevel');
      expect(filter(LEVEL_ROLE_ADMIN)).toBe(LEVEL_ROLE_ADMIN_STRING);
    }));

    it('should map ' + LEVEL_ROLE_STAFF + ' to ' + LEVEL_ROLE_STAFF_STRING, inject(function($filter) {
      var filter = $filter('filterUserLevel');
      expect(filter(LEVEL_ROLE_STAFF)).toBe(LEVEL_ROLE_STAFF_STRING);
    }));

    it('should map ' + LEVEL_ROLE_STUDENT + ' to ' + LEVEL_ROLE_STUDENT_STRING, inject(function($filter) {
      var filter = $filter('filterUserLevel');
      expect(filter(LEVEL_ROLE_STUDENT)).toBe(LEVEL_ROLE_STUDENT_STRING);
    }));
  }); 
});