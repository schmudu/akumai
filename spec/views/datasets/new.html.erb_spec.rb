require 'spec_helper'

describe "datasets/new" do
  before(:each) do
    assign(:dataset, stub_model(Dataset).as_new_record)
  end

=begin
  it "renders new dataset form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", datasets_path, "post" do
    end
  end
=end
end
