require 'spec_helper'

describe Program do
  before do
    @program = FactoryGirl.create(:program) 
  end

  subject { @program }

  it { should respond_to(:name) }
  it { should respond_to(:code) }
  it { should be_valid }

  describe "name validations" do
    describe "should not be valid with exclamation point" do
      before { @program.name = "!ABC123456" }
      it { should_not be_valid }
    end
  end
end
