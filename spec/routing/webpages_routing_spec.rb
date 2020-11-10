require "rails_helper"

RSpec.describe WebpagesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/webpages").to route_to("webpages#index")
    end

    it "routes to #new" do
      expect(get: "/webpages/new").to route_to("webpages#new")
    end

    it "routes to #show" do
      expect(get: "/webpages/1").to route_to("webpages#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/webpages/1/edit").to route_to("webpages#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/webpages").to route_to("webpages#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/webpages/1").to route_to("webpages#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/webpages/1").to route_to("webpages#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/webpages/1").to route_to("webpages#destroy", id: "1")
    end
  end
end
