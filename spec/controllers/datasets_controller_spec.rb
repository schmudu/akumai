require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.


describe DatasetsController do

=begin
  # This should return the minimal set of attributes required to create a valid
  # Dataset. As you add validations to Dataset, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { {  } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DatasetsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all datasets as @datasets" do
      dataset = Dataset.create! valid_attributes
      get :index, {}, valid_session
      assigns(:datasets).should eq([dataset])
    end
  end

  describe "GET show" do
    it "assigns the requested dataset as @dataset" do
      dataset = Dataset.create! valid_attributes
      get :show, {:id => dataset.to_param}, valid_session
      assigns(:dataset).should eq(dataset)
    end
  end

  describe "GET new" do
    it "assigns a new dataset as @dataset" do
      get :new, {}, valid_session
      assigns(:dataset).should be_a_new(Dataset)
    end
  end

  describe "GET edit" do
    it "assigns the requested dataset as @dataset" do
      dataset = Dataset.create! valid_attributes
      get :edit, {:id => dataset.to_param}, valid_session
      assigns(:dataset).should eq(dataset)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Dataset" do
        expect {
          post :create, {:dataset => valid_attributes}, valid_session
        }.to change(Dataset, :count).by(1)
      end

      it "assigns a newly created dataset as @dataset" do
        post :create, {:dataset => valid_attributes}, valid_session
        assigns(:dataset).should be_a(Dataset)
        assigns(:dataset).should be_persisted
      end

      it "redirects to the created dataset" do
        post :create, {:dataset => valid_attributes}, valid_session
        response.should redirect_to(Dataset.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved dataset as @dataset" do
        # Trigger the behavior that occurs when invalid params are submitted
        Dataset.any_instance.stub(:save).and_return(false)
        post :create, {:dataset => {  }}, valid_session
        assigns(:dataset).should be_a_new(Dataset)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Dataset.any_instance.stub(:save).and_return(false)
        post :create, {:dataset => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested dataset" do
        dataset = Dataset.create! valid_attributes
        # Assuming there are no other datasets in the database, this
        # specifies that the Dataset created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Dataset.any_instance.should_receive(:update).with({ "these" => "params" })
        put :update, {:id => dataset.to_param, :dataset => { "these" => "params" }}, valid_session
      end

      it "assigns the requested dataset as @dataset" do
        dataset = Dataset.create! valid_attributes
        put :update, {:id => dataset.to_param, :dataset => valid_attributes}, valid_session
        assigns(:dataset).should eq(dataset)
      end

      it "redirects to the dataset" do
        dataset = Dataset.create! valid_attributes
        put :update, {:id => dataset.to_param, :dataset => valid_attributes}, valid_session
        response.should redirect_to(dataset)
      end
    end

    describe "with invalid params" do
      it "assigns the dataset as @dataset" do
        dataset = Dataset.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Dataset.any_instance.stub(:save).and_return(false)
        put :update, {:id => dataset.to_param, :dataset => {  }}, valid_session
        assigns(:dataset).should eq(dataset)
      end

      it "re-renders the 'edit' template" do
        dataset = Dataset.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Dataset.any_instance.stub(:save).and_return(false)
        put :update, {:id => dataset.to_param, :dataset => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested dataset" do
      dataset = Dataset.create! valid_attributes
      expect {
        delete :destroy, {:id => dataset.to_param}, valid_session
      }.to change(Dataset, :count).by(-1)
    end

    it "redirects to the datasets list" do
      dataset = Dataset.create! valid_attributes
      delete :destroy, {:id => dataset.to_param}, valid_session
      response.should redirect_to(datasets_url)
    end
  end
=end

end
