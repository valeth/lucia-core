require "rails_helper"

RSpec.describe ::API::V1::Sigma::Donors do
  context "GET /rest/v1/sigma/donors" do
    it "returns a list of donors" do
      get "/rest/v1/sigma/donors"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result.size).to eq(1)
      expect(result).to eq [{
        "tier" => 1,
        "user" => {
          "id" => 217078934976724992,
          "name" => "Test217078934976724992",
          "avatar_url" => "https://cdn.discordapp.com/avatars/217078934976724992/8342729096ea3675442027381ff50dfe.png",
          "discriminator" => "4992"
        }
      }]
    end
  end
end
