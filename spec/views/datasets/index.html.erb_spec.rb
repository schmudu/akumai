require 'spec_helper'

describe "datasets/index" do
  before(:each) do
    assign(:datasets, [
      stub_model(Dataset),
      stub_model(Dataset)
    ])
  end

  it "renders a list of datasets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
