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
    @dataset.creator_id = @superuser.id
    @dataset.attachment = File.open(get_attachment_file_path("data_sample.csv"),"r")
    @dataset.program_id = @program.id
  end

  subject { @dataset }

  # attributes
  it { should respond_to(:attachment) }
  it { should respond_to(:creator) }
  it { should respond_to(:dataset_entries) }
  it { should respond_to(:program) }
  it { should respond_to(:program_id) }
  it { should be_valid }

  # test instance methods
  describe "instance methods" do
  end

  # test validity
  describe "properties" do
    describe "attachment" do
      describe "not valid" do
        describe "if set to nil" do
          before { @dataset.attachment = nil }
          it { should_not be_valid }
        end

        describe "if set to doc file" do
          before { @dataset.attachment = File.open(get_attachment_file_path("hello_world.doc"),"r") }
          it { should_not be_valid }
        end

        describe "if set to docx file" do
          before { @dataset.attachment = File.open(get_attachment_file_path("hello_world.docx"),"r") }
          it { should_not be_valid }
        end
      end
    end

    describe "creator_id" do
      describe "not valid" do
        describe "if set to non-existent user" do
          before { @dataset.creator_id = -99 }
          it { should_not be_valid }
        end

        describe "if set to nil" do
          before { @dataset.creator_id = nil }
          it { should_not be_valid }
        end

        describe "if set to blank" do
          before { @dataset.creator_id = "" }
          it { should_not be_valid }
        end
      end
    end

    describe "program_id" do
      describe "not valid" do
        describe "if set to non-existent user" do
          before { @dataset.program_id = -99 }
          it { should_not be_valid }
        end

        describe "if set to nil" do
          before { @dataset.program_id = nil }
          it { should_not be_valid }
        end

        describe "if set to blank" do
          before { @dataset.program_id = "" }
          it { should_not be_valid }
        end
      end
    end

  end

  describe "delayed jobs creation" do
    before do
      ResqueSpec.reset!
    end

    it "queues mail when a contact is created" do
      @dataset.save
      DatasetCreationJob.should have_queued(@dataset.id).in(:dataset)
    end
  end

end

