require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe "InvitationPages" do
  let(:user) { FactoryGirl.create(:user, superuser: false) }
  let(:program) { FactoryGirl.create(:program, name:"Program_Name") }
  before(:each) { login user }
  subject { page }
  describe "invite users" do
    describe "without logging in" do
      before do   
        logout user
        visit invite_users_path
      end 

      it "path should go to invite users path" do
        current_path.should == new_user_session_path
      end
    end

    describe "with logging in" do
      let (:program_admin) { FactoryGirl.create(:program, name:"Program_Admin")}
      let (:program_staff) { FactoryGirl.create(:program, name:"Program_Staff")}
      let (:program_student) { FactoryGirl.create(:program, name:"Program_Student")}

      before do   
        FactoryGirl.create(:role, user_id:user.id, program_id:program_admin.id, level:ConstantsHelper::ROLE_LEVEL_ADMIN)
        FactoryGirl.create(:role, user_id:user.id, program_id:program_staff.id, level:ConstantsHelper::ROLE_LEVEL_STAFF)
        FactoryGirl.create(:role, user_id:user.id, program_id:program_student.id, level:ConstantsHelper::ROLE_LEVEL_STUDENT)
        visit invite_users_path
      end 

      it "path should go to invite users path" do
        current_path.should == invite_users_path
      end

      describe "should have appropriate controls" do
        it { should have_selector("label", :text => "Program") }
        it { should have_selector("label", :text => "Student") }
        it { should have_selector("option", :text => "Program_Admin") }
        it { should have_selector("option", :text => "Program_Staff") }
        it { should_not have_selector("option", :text => "Program_Student") }
      end

      describe "user level types should be modified based on the program selected" do
        describe "select admin program" do
          before do
            select('Program_Admin', from: 'program_id')
          end

          it { should_not have_css('input#level_admin.disabled')}
          it { should_not have_css('input#level_staff.disabled')}
          it { should_not have_css('input#level_student.disabled')}
        end

        describe "select staff program" do
          pending "need to add tests for ajax request"
=begin
          before do
          #within "#invite_users" do
            select('Program_Staff', from: 'program_id')
            #fill_in "email_addresses", :with => "Are you sure?"
            #expect(page).to have_content("Are you sure?")
          end

          #it { should have_css('input#level_admin.disabled', :visible => true)}
          #it { should have_css('input#level_staff.disabled')}
          #it { should_not have_css('input#level_student.disabled')}
          it "should alter input" do
            page.find("#label_admin").should have_selector('input#level_admin.disabled')
            #print page.html
            #save_and_open_page
            #expect(page).to have_selector('input#level_admin.disabled')
            #expect(page).to have_selector('input#level_admin')
            #page.should have_xpath("//input[@type='radio' and @id='level_admin']")
            #page.should have_xpath("//input[@type='radio' and @id='level_admin' and @class='disabled']")
            #page.should have_xpath("//input[@type='radio' and @id='level_admin']", :class => "disabled")
            #page.should have_select(:xpath, "//input[@type='radio' and @id='level_staff' and @class='disabled']")
            #page.should have_no_select(:xpath, "//input[@type='radio' and @id='level_student' and @class='disabled']")
          end
=end
        end
      end

      describe "superuser should have all programs" do
        let(:superuser) { FactoryGirl.create(:user, superuser: true) }
        subject { page }

        before do
          logout user
          login superuser
          visit invite_users_path
        end

        describe "should have appropriate controls" do
          it { should have_selector("option", :text => "Program_Admin") }
          it { should have_selector("option", :text => "Program_Staff") }
          it { should have_selector("option", :text => "Program_Student") }
        end
      end

      describe "submitting invitation" do
        describe "filling out valid information" do
          before do
            select('Program_Staff', from: 'program_id')
            choose('radio_student')
            fill_in "email_addresses", :with => "patrick@abc.com"
            click_button I18n.t('invitations.form.buttons.review_invitations')
          end

          it "should go to review invitations path" do
            current_path.should == review_invitations_path
          end

          it { should have_content("Step 2 of 2") }
        end

        describe "filling out with invalid information" do
          describe "do not select a program" do
            before do
              #select('Program_Staff', from: 'program_id')
              choose('radio_student')
              fill_in "email_addresses", :with => "patrick@abc.com"
              click_button I18n.t('invitations.form.buttons.review_invitations')
            end

            it { should have_content(I18n.t 'invitations.form.errors.program')}
            it { should have_selector('div#program_group.error') }
            it { should have_xpath("//input[@id='radio_student' and @checked='checked']")}

          end

          describe "do not select an invitation type" do
            before do
              select('Program_Staff', from: 'program_id')
              #choose('radio_student')
              fill_in "email_addresses", :with => "patrick@abc.com"
              click_button I18n.t('invitations.form.buttons.review_invitations')
            end

            it { should have_content(I18n.t 'invitations.form.errors.invitation_type_none')}
            it { should have_selector('div#invitation_group.error') }
            it { should have_xpath("//option[@value='program_staff' and @selected='selected']")}
          end

          describe "do not enter an email address" do
            before do
              select('Program_Staff', from: 'program_id')
              choose('radio_student')
              fill_in "email_addresses", :with => ""
              click_button I18n.t('invitations.form.buttons.review_invitations')
            end

            it { should have_content(I18n.t 'invitations.form.errors.email_blank')}
            it { should have_selector('div#email_group.error') }
            it { should have_xpath("//input[@id='radio_student' and @checked='checked']")}
            it { should have_xpath("//option[@value='program_staff' and @selected='selected']")}
          end

          describe "do nothing with email" do
            before do
              select('Program_Staff', from: 'program_id')
              choose('radio_student')
              fill_in "email_addresses", :with => I18n.t('invitations.form.prompt.default_email')
              click_button I18n.t('invitations.form.buttons.review_invitations')
            end

            it { should have_content(I18n.t 'invitations.form.errors.email_blank')}
            it { should have_selector('div#email_group.error') }
            it { should have_xpath("//input[@id='radio_student' and @checked='checked']")}
            it { should have_xpath("//option[@value='program_staff' and @selected='selected']")}
          end

          describe "enter an invalid email" do
            before do
              select('Program_Staff', from: 'program_id')
              choose('radio_student')
              fill_in "email_addresses", :with => "abc.com"
              click_button I18n.t('invitations.form.buttons.review_invitations')
            end

            it { should have_content(I18n.t 'invitations.form.errors.email_format')}
            it { should have_selector('div#email_group.error') }
            it { should have_xpath("//input[@id='radio_student' and @checked='checked']")}
            it { should have_xpath("//option[@value='program_staff' and @selected='selected']")}
          end

          describe "do not enter any information" do
            before do
              fill_in "email_addresses", :with => ""

              click_button I18n.t('invitations.form.buttons.review_invitations')
            end

            it { should have_content(I18n.t 'invitations.form.errors.email_blank')}
            it { should have_content(I18n.t 'invitations.form.errors.invitation_type_none')}
            it { should have_content(I18n.t 'invitations.form.errors.program')}
            it { should have_selector('div#email_group.error') }
            it { should have_selector('div#invitation_group.error') }
            it { should have_selector('div#program_group.error') }
          end
        end
      end
    end
  end
end
