require "spec_helper"

describe InvitationsController do
  describe "routing" do

    it "routes to #index" do
      get("/invitations").should route_to("invitations#index")
    end

    it "routes to #new" do
      get("/invitations/new").should route_to("invitations#new")
    end

    it "routes to #show" do
      get("/invitations/1").should route_to("invitations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/invitations/1/edit").should route_to("invitations#edit", :id => "1")
    end

    it "routes to #address" do
      post("/invitations/address").should route_to("invitations#address")
    end

    it "routes to #review" do
      post("/invitations/review").should route_to("invitations#review")
    end

    it "routes to #send" do
      post("/invitations/confirm").should route_to("invitations#confirm")
    end

    it "routes to #update" do
      put("/invitations/1").should route_to("invitations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/invitations/1").should route_to("invitations#destroy", :id => "1")
    end

  end
end
