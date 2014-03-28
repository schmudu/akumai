require 'spec_helper'

describe "datasets/show" do
  before(:each) do
    @dataset = assign(:dataset, stub_model(Dataset))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
