require 'spec_helper'

require_relative '../../app/helpers/constants_helper'

def create_test_invite(user_level, invitation_id)
  invite = FactoryGirl.build(:invite)
  invite.code = "abc"
  invite.email = "abc@abc.com"
  invite.student_id = "abc01"
  invite.user_level = user_level
  invite.invitation_id = invitation_id
  invite.status = ConstantsHelper::INVITE_STATUS_SENT
  invite.save
  return invite
end

def create_test_invitation(user_id, program_id, user_level)
  invitation = Invitation.new
  invitation.name = "Random Invitation"
  invitation.creator_id = user_id
  invitation.program_id = program_id
  invitation.user_level = user_level
  invitation.recipient_emails = ""
  invitation.status = ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
  invitation.save
  return invitation
end

describe "InvitePages" do
  before do
    @program = Program.create(:name => "Program Name") 
    @superuser = FactoryGirl.create(:user, :superuser => true)
    @password = "foobar123"
  end
  let(:superuser) { FactoryGirl.create(:user, :email => "superuser@abc.com", :superuser => true) }

  subject { page }

  describe "signup path" do
    before do
      login superuser
    end
    describe "content" do
      describe "non-student invite" do
        before(:each) do 
          @invitation = create_test_invitation(@superuser.id, @program.id, ConstantsHelper::ROLE_LEVEL_STAFF)
          @invite = create_test_invite(ConstantsHelper::ROLE_LEVEL_STAFF, @invitation.id)
          visit invites_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
        end
        it { current_path.should == invites_signup_path }
      end

      describe "student invite" do
        before(:each) do 
          @invitation = create_test_invitation(@superuser.id, @program.id, ConstantsHelper::ROLE_LEVEL_STUDENT)
          @invite = create_test_invite(ConstantsHelper::ROLE_LEVEL_STUDENT, @invitation.id)
          visit invites_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
        end
        it { current_path.should == invites_signup_path }
        it { should have_content(I18n.t('terms.student_id'))}
      end
    end
    describe "submitting content" do
      describe "non-student invite" do
        before(:each) do 
          @invitation = create_test_invitation(@superuser.id, @program.id, ConstantsHelper::ROLE_LEVEL_STAFF)
          @invite = create_test_invite(ConstantsHelper::ROLE_LEVEL_STAFF, @invitation.id)
          visit invites_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
          fill_in "user_password", :with => @password
          fill_in "user_password_confirmation", :with => @password
        end


        describe "valid content" do
          describe "accept click" do
            it "should increase role count" do
              expect do
                click_button I18n.t('terms.accept_invite')
              end.to change{Role.count}.by(1)
            end

            #it {save_and_open_page}

            it "should increase user count" do
              expect do
                click_button I18n.t('terms.accept_invite')
              end.to change{User.count}.by(1)
            end

            describe "path and invite status" do
              before do
                click_button I18n.t('terms.accept_invite')
              end

              it { current_path.should == dashboard_path }
              it "should set invite status to accepted" do
                expect(@invite.reload.status).to eq(ConstantsHelper::INVITE_STATUS_ACCEPTED) 
              end
            end
          end

          describe "reject click" do
            before do
              click_button I18n.t('terms.reject_invite')
            end

            it { current_path.should == invites_respond_signup_path }
            it "should set invite status to rejection" do
              expect(@invite.reload.status).to eq(ConstantsHelper::INVITE_STATUS_REJECTED) 
            end
          end
        end

        describe "invalid content" do
          describe "missing content" do
            describe "missing password" do
              before do
                fill_in "user_password", :with => ""
                click_button I18n.t('terms.accept_invite')
              end
              it { should have_content('error')}
            end

            describe "missing password confirmation" do
              before do
                fill_in "user_password_confirmation", :with => ""
                click_button I18n.t('terms.accept_invite')
              end
              it { should have_content('error')}
            end
          end

          describe "revisit invite after response" do
            describe "accept invite and then revisit link should throw error" do
              before do
                click_button I18n.t('terms.accept_invite')
                visit invites_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
              end

              it { should have_content(I18n.t('invites.form.errors.inactive'))}
            end

            describe "reject invite and then revisit link should throw error" do
              before do
                click_button I18n.t('terms.reject_invite')
                visit invites_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
              end

              it { should have_content(I18n.t('invites.form.errors.inactive'))}
            end
          end
          pending "create tests to validate that invite parameters are correct"
        end
      end

      describe "student invite" do
        before do
          @invitation = create_test_invitation(@superuser.id, @program.id, ConstantsHelper::ROLE_LEVEL_STUDENT)
          @invite = create_test_invite(ConstantsHelper::ROLE_LEVEL_STUDENT, @invitation.id)
          visit invites_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
          fill_in "user_password", :with => @password
          fill_in "user_password_confirmation", :with => @password
          fill_in "invite_student_id", :with => @invite.student_id
        end
        #it { save_and_open_page}
        describe "valid content" do
          describe "accept click" do
            it "should increase role count" do
              expect do
                click_button I18n.t('terms.accept_invite')
              end.to change{Role.count}.by(1)
            end

            #it {save_and_open_page}

            it "should increase user count" do
              expect do
                click_button I18n.t('terms.accept_invite')
              end.to change{User.count}.by(1)
            end

            describe "path and invite status" do
              before do
                click_button I18n.t('terms.accept_invite')
              end

              it { current_path.should == dashboard_path }
              it "should set invite status to accepted" do
                expect(@invite.reload.status).to eq(ConstantsHelper::INVITE_STATUS_ACCEPTED) 
              end
            end
          end

          describe "reject click" do
            before do
              click_button I18n.t('terms.reject_invite')
            end

            it { current_path.should == invites_respond_signup_path }
            it "should set invite status to rejection" do
              expect(@invite.reload.status).to eq(ConstantsHelper::INVITE_STATUS_REJECTED) 
            end
          end
        end

        describe "invalid content" do
          describe "missing content" do
            describe "missing password" do
              before do
                fill_in "user_password", :with => ""
                click_button I18n.t('terms.accept_invite')
              end
              it { should have_content('error')}
            end

            describe "missing password confirmation" do
              before do
                fill_in "user_password_confirmation", :with => ""
                click_button I18n.t('terms.accept_invite')
              end
              it { should have_content('error')}
            end

            describe "incorrect student id" do
              before do
                fill_in "invite_student_id", :with => "crazy_town"
                click_button I18n.t('terms.accept_invite')
              end
              it { should have_content('error')}
            end
          end

          describe "revisit invite after response" do
            describe "accept invite and then revisit link should throw error" do
              before do
                click_button I18n.t('terms.accept_invite')
                visit invites_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
              end

              it { should have_content(I18n.t('invites.form.errors.inactive'))}
            end

            describe "reject invite and then revisit link should throw error" do
              before do
                click_button I18n.t('terms.reject_invite')
                visit invites_signup_path(:id => @invite.slug, :code => @invite.code, :email => @invite.email)
              end

              it { should have_content(I18n.t('invites.form.errors.inactive'))}
            end
          end
          pending "create tests to validate that invite parameters are correct"
        end
      end
    end
  end
end
