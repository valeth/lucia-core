# frozen_string_literal: true

require "rails_helper"

RSpec.describe GraphqlController do
  context "authentication" do
    it "returns status 401 on empty token" do
      post :execute
      expect(response.status).to eq(401)
    end

    it "returns status 403 if token is invalid" do
      @request.headers["X-Lucia-Token"] = "lc-a050aeda033d257d34be239bcd810040"
      post :execute
      expect(response.status).to eq(403)
    end

    it "returns status 200 if token is valid" do
      @request.headers["X-Lucia-Token"] = "lc-cd40471e85312c278a6a17b9bd53a388"
      post :execute
      expect(response.status).to eq(200)
    end
  end
end
