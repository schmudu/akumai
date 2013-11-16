require 'spec_helper'
require_relative '../../app/helpers/constants_helper'

describe Invitation do
  before do
    @invitation = FactoryGirl.create(:invitation)
  end

  subject { @invitation }

  it { should respond_to(:email) }
  it { should respond_to(:recipients) }
end
