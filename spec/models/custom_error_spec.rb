require 'spec_helper'

describe CustomError do
  before do
    @error = FactoryGirl.build(:custom_error)
    @program = FactoryGirl.create(:program)
  end

  subject { @error }

  # attributes
  it { should respond_to(:program) }
  it { should respond_to(:resource) }
  it { should respond_to(:comment) }

  describe "attributes" do
    before do
      @error.comment = "Resource 1 not valid"
      @error.program_id = @program.id
      @error.resource = "Invite"
    end

    it { should be_valid }

    describe "program_id" do
      describe "should not be nil" do
        before do
          @error.program_id = nil
        end

        it { should_not be_valid }
      end

      describe "should not reference id that is non-existent" do
        before do
          @error.program_id = -99
        end

        it { should_not be_valid }
      end
    end

    describe "resource" do
      describe "should not be blank" do
        before do
          @error.resource = ""
          @error.save
        end

        it { should_not be_valid }
      end

      describe "should not be nil" do
        before do
          @error.resource = nil
        end

        it { should_not be_valid }
      end
    end

    describe "comment" do
      describe "should not be blank" do
        before do
          @error.comment = ""
          @error.save
        end

        it { should_not be_valid }
      end

      describe "should not be nil" do
        before do
          @error.comment = nil
        end

        it { should_not be_valid }
      end
    end
  end
end
