require 'spec_helper'

describe Program do
  before do
    @program = FactoryGirl.create(:program)
  end

  subject { @program }

  it { should respond_to(:name) }
  it { should respond_to(:code) }
end
