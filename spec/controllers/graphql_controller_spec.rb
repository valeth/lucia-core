# frozen_string_literal: true

require "rails_helper"

RSpec.describe GraphqlController do
  context "authentication" do
    let(:valid_token) { "lc-cd40471e85312c278a6a17b9bd53a388" }
    let(:invalid_token) { "lc-a050aeda033d257d34be239bcd810040" }

    it "returns status 401 on missing or empty auth token" do
      post :execute
      expect(response.status).to eq(401)
    end

    it "returns status 403 if token is invalid" do
      @request.headers["Authorization"] = "Token #{invalid_token}"
      post :execute
      expect(response.status).to eq(403)
    end

    before do
      LuciaToken::Authenticator.mark_token_as_unused(valid_token)
    end

    it "returns status 403 if token is used before reset" do
      @request.headers["Authorization"] = "Token #{valid_token}"

      post :execute
      expect(response.status).to eq(200)

      post :execute
      expect(response.status).to eq(403)
    end

    before do
      LuciaToken::Authenticator.mark_token_as_unused(valid_token)
    end

    it "returns status 200 if token is valid" do
      @request.headers["Authorization"] = "Token #{valid_token}"
      post :execute
      expect(response.status).to eq(200)
    end
  end
end
