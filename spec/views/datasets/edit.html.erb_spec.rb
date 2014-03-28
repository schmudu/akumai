require 'spec_helper'

describe "datasets/edit" do
  before(:each) do
    @dataset = assign(:dataset, stub_model(Dataset))
  end

  it "renders the edit dataset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", dataset_path(@dataset), "post" do
    end
  end
end
