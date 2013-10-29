require 'spec_helper'

describe Program do
  before do
    @program = FactoryGirl.create(:program) 
  end

  subject { @program }

  it { should respond_to(:name) }
  it { should be_valid }

  describe "name validations" do
    describe "should not be valid with empty name" do
      before { @program.name = "" }
      it { should_not be_valid }
    end

    describe "should not be valid with blank name" do
      before { @program.name = " " }
      it { should_not be_valid }
    end

    describe "should be valid with underline" do
      before { @program.name = "_ABC123456" }
      it { should be_valid }
    end

    describe "should not be valid with exclamation point" do
      before { @program.name = "!ABC123456" }
      it { should_not be_valid }
    end

    describe "should be valid with lower and uppercase letters and numbers" do
      before { @program.name = "abcDEF123" }
      it { should be_valid }
    end
  end
end
