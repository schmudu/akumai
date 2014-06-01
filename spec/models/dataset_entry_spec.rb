require 'spec_helper'

describe DatasetEntry do
  before do
    @superuser = FactoryGirl.create(:user, :superuser => true)
    @program = FactoryGirl.create(:program)

    # role
    @user = FactoryGirl.create(:user)
    @role = FactoryGirl.create(:role, :user_id => @user.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT)

    # dataset
    @dataset = FactoryGirl.build(:dataset)
    @dataset.creator_id = @superuser.id
    @dataset.attachment = File.open(get_attachment_file_path("data_sample.csv"),"r")
    @dataset.program_id = @program.id
    @dataset.save

    @entry = FactoryGirl.build(:dataset_entry)
    @entry.data = "A"
    @entry.dataset_id = @dataset.id
    @entry.date = Date.parse("20130601")
    @entry.role_id = @role.id
  end

  subject { @entry }

  # attributes
  it { should respond_to(:data) }
  it { should respond_to(:dataset) }
  it { should respond_to(:dataset_id) }
  it { should respond_to(:date) }
  it { should respond_to(:role) }
  it { should respond_to(:role_id) }
  it { should be_valid }

  describe "attributes" do
    describe "data" do
      describe "should not be valid if nil" do
        before { @entry.data = nil }
        it { should_not be_valid }
      end
    end

    describe "dataset" do
      describe "should not be valid if nil" do
        before { @entry.dataset_id = nil }
        it { should_not be_valid }
      end

      describe "should not be valid if set to non-existent dataset_id" do
        before { @entry.dataset_id = -99 }
        it { should_not be_valid }
      end
    end

    describe "date" do
      describe "should not be valid if nil" do
        before { @entry.date = nil }
        it { should_not be_valid }
      end
    end

    describe "role" do
      describe "should not be valid if nil" do
        before { @entry.role_id = nil }
        it { should_not be_valid }
      end

      describe "should not be valid if set to non-existent dataset_id" do
        before { @entry.role_id = -99 }
        it { should_not be_valid }
      end
    end
  end
end
