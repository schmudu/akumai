require 'spec_helper'

describe "Datasets" do
  let(:staff) { FactoryGirl.create(:user, :email => "staff@abc.com", :superuser => true) }
  let(:superuser) { FactoryGirl.create(:user, :email => "superuser@abc.com", :superuser => true) }
  let(:user_student) { FactoryGirl.create(:user, email: "student@abc.com", superuser: false) }
  let(:user_admin) { FactoryGirl.create(:user, email: "admin@abc.com", superuser: false) }
  let(:program) { FactoryGirl.create(:program, name:"Program Name") }
  let(:role_staff) { FactoryGirl.create(:role, :user_id => @user_staff.id, :program_id => program.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN, :student_id => nil)}
  let(:role_admin) { FactoryGirl.create(:role, :user_id => @user_admin.id, :program_id => program.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN, :student_id => nil)}
  let(:role_student) { FactoryGirl.create(:role, :user_id => @user_student.id, :program_id => program.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN, :student_id => "a001")}
  subject { page }

  describe "superuser" do
    before(:each) do 
      login superuser 
      visit new_dataset_path(:id => program.slug)
    end

    describe "attach csv file" do
      before do
        fill_in "dataset_effective_at", :with => "19-April-2014"
        attach_file "dataset_attachment", "#{Rails.root}/spec/fixtures/files/data_sample.csv"
        click_button "Create Dataset"
      end

      it { save_and_open_page }
      it { should have_content('error')}
      it { current_path.should == datasets_path }
    end
  end
end
