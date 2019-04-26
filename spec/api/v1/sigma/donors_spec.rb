require "rails_helper"

RSpec.describe ::API::V1::Sigma::Donors do
  context "GET /rest/v1/sigma/donors" do
    before do
      Donor.find_or_create_by(duid: 217078934976724992) do |m|
        m.tier = 1
      end
    end

    it "returns a list of donors" do
      get "/rest/v1/sigma/donors"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result.size).to eq(1)
      expect(result).to eq [{
        "duid" => 217078934976724992,
        "tier" => 1,
        "name" => "Test217078934976724992",
        "avatar" => "https://cdn.discordapp.com/avatars/217078934976724992/8342729096ea3675442027381ff50dfe.png"
      }]
    end
  end
end
