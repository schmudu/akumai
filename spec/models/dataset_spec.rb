require 'spec_helper'

describe Dataset do
  before do
    @superuser = FactoryGirl.create(:user, :superuser => true)
    @staff_in_program = FactoryGirl.create(:user, :email => "staff_in_program@example.com")
    @student_in_program = FactoryGirl.create(:user, :email => "student_in_program@example.com")
    @admin_in_program = FactoryGirl.create(:user, :email => "admin_in_program@example.com")
    @user_outside_of_program = FactoryGirl.create(:user, :email => "user_outside@abc.com")
    @program = FactoryGirl.create(:program)

    # dataset
    @dataset = FactoryGirl.build(:dataset)
  end

  subject { @dataset }

  # attributes
  it { should respond_to(:creator) }
  it { should respond_to(:attachment) }
  it { should respond_to(:program) }
  it { should respond_to(:program_id) }

  # test instance methods
  describe "instance methods" do
  end

  #Dataset.new(:attachment => File.open(File.join(Rails.root,"/spec/fixtures/files/",file_name),"r"))

end

