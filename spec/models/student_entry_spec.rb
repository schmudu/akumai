require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe StudentEntry do
  before do
    @email_valid = "abc@abc.com"
    @program = FactoryGirl.create(:program)
    @superuser = FactoryGirl.create(:user, :superuser => true)
    @invitation = FactoryGirl.create(:invitation, :creator_id => @superuser.id, :program_id => @program.id, :user_level => ConstantsHelper::ROLE_LEVEL_STUDENT, :status => ConstantsHelper::INVITATION_STATUS_SETUP_TYPE)
    @student_entry = StudentEntry.new
  end

  subject { @student_entry }

  describe "valid" do
    before do
      @student_entry.email = @email_valid
      @student_entry.validation_bypass = false
      @student_entry.invitation_id = @invitation.id
      @student_entry.student_id = "aaa0001"
    end

    it { should be_valid }

    describe "with false validation_bypass" do

    end

    describe "with true validation_bypass" do
      describe "email attribute" do
        describe "nil email" do
          before do 
            @student_entry.validation_bypass = true
            @student_entry.email = nil 
          end
          it { should be_valid }
        end

        describe "blank email" do
          before do
            @student_entry.validation_bypass = true
            @student_entry.email = ""
          end 
          it { should be_valid }
        end

        describe "invalid email" do
          before do
            @student_entry.validation_bypass = true
            @student_entry.email = "abcd@abc"
          end 
          it { should be_valid }
        end

        describe "multiple emails" do
          before do
            @student_entry.validation_bypass = true
            @student_entry.email = "abc@abc.com, def@def.com"
          end 
          it { should be_valid }
        end

        describe "duplicate emails" do
          before do
            @student_email = "abc@abc.com"
            @student_entry_original = FactoryGirl.create(:student_entry, :email => @student_email, :invitation_id => @invitation.id, :student_id => "b001")
            @student_entry_duplicate = FactoryGirl.build(:student_entry, :email => @student_email, :invitation_id => @invitation.id, :student_id => "c001")
            @student_entry_duplicate.validation_bypass = true
          end

          it "duplicate email" do
            @student_entry_duplicate.should be_valid
          end
        end
      end

      describe "student_id" do
        describe "set to nil" do
          before do 
            @student_entry.validation_bypass = true
            @student_entry.student_id = nil 
          end
          it { should be_valid }
        end

        describe "set to blank" do
          before do 
            @student_entry.validation_bypass = true
            @student_entry.student_id = ""
          end
          it { should be_valid }
        end

        describe "duplicate student_id" do
          before do
            @student_id = "aa001"
            @student_entry_original = FactoryGirl.create(:student_entry, :email => @email_valid, :invitation_id => @invitation.id, :student_id => @student_id)
            @student_entry_duplicate = FactoryGirl.build(:student_entry, :email => "something@else.com", :invitation_id => @invitation.id, :student_id => @student_id)
            @student_entry_duplicate.validation_bypass = true
          end

          it "duplicate student_id" do
            @student_entry_duplicate.should be_valid
          end
        end
      end
    end
  end

  describe "invalid" do
    before do
      @student_entry.email = @email_valid
      @student_entry.validation_bypass = false
      @student_entry.invitation_id = @invitation.id
      @student_entry.student_id = "aaa0001"
    end

    it { should be_valid }

    describe "with false validation_bypass" do
      describe "email attribute" do
        describe "nil email" do
          before { @student_entry.email = nil }
          it { should_not be_valid }
        end

        describe "blank email" do
          before { @student_entry.email = "" }
          it { should_not be_valid }
        end

        describe "invalid email" do
          before { @student_entry.email = "abcd@abc" }
          it { should_not be_valid }
        end

        describe "multiple emails" do
          before { @student_entry.email = "abc@abc.com, def@def.com" }
          it { should_not be_valid }
        end

        describe "duplicate emails" do
          before do
            @student_email = "abc@abc.com"
            @student_entry_original = FactoryGirl.create(:student_entry, :email => @student_email, :invitation_id => @invitation.id, :student_id => "b001")
            @student_entry_duplicate = FactoryGirl.build(:student_entry, :email => @student_email, :invitation_id => @invitation.id, :student_id => "c001")
          end

          it "duplicate email" do
            @student_entry_duplicate.should_not be_valid
          end
        end
      end

      describe "invitation_id" do
        describe "set to nil" do
          before { @student_entry.invitation_id = nil }
          it { should_not be_valid }
        end

        describe "set to non-existent invitation" do
          before { @student_entry.invitation_id = -99 }
          it { should_not be_valid }
        end
      end

      describe "student_id" do
        describe "set to nil" do
          before { @student_entry.student_id = nil }
          it { should_not be_valid }
        end

        describe "set to blank" do
          before { @student_entry.student_id = "" }
          it { should_not be_valid }
        end

        describe "duplicate student_id" do
          before do
            @student_id = "aa001"
            @student_entry_original = FactoryGirl.create(:student_entry, :email => @email_valid, :invitation_id => @invitation.id, :student_id => @student_id)
            @student_entry_duplicate = FactoryGirl.build(:student_entry, :email => "something@else.com", :invitation_id => @invitation.id, :student_id => @student_id)
          end

          it "duplicate student_id" do
            @student_entry_duplicate.should_not be_valid
          end
        end
      end
    end

    describe "with true validation_bypass" do
      describe "email and student id" do
        describe "set to nil even with validation bypass it should fail" do
          before do 
            @student_entry.validation_bypass = true 
            @student_entry.email = nil
            @student_entry.student_id = nil
          end

          it { should_not be_valid }
        end

        describe "set to blank even with validation bypass it should fail" do
          before do 
            @student_entry.validation_bypass = true 
            @student_entry.email = ""
            @student_entry.student_id = nil
          end

          it { should_not be_valid }
        end
      end

      describe "invitation_id" do
        describe "set to nil even with validation bypass it should fail" do
          before do 
            @student_entry.invitation_id = nil 
            @student_entry.validation_bypass = true 
          end

          it { should_not be_valid }
        end

        describe "set to nil even with validation bypass it should fail" do
          before do 
            @student_entry.invitation_id = -99 
            @student_entry.validation_bypass = true 
          end

          it { should_not be_valid }
        end
      end
    end
  end
end
