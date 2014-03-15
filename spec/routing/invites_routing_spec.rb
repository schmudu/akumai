require "spec_helper"

describe InvitesController do
  describe "routing" do
    it "routes to #show" do
      get("/invites/show").should route_to("invites#show")
    end

    it "routes to #signup" do
      get("/invites/signup").should route_to("invites#signup")
    end

    it "routes to #show" do
      post("/invites/respond").should route_to("invites#respond")
    end
  end
end
