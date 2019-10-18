require "rails_helper"

RSpec.describe ::API::V1::Sigma::Donors do
  context "GET /rest/v1/sigma/donors" do
    it "returns a list of donors" do
      get "/rest/v1/sigma/donors"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result.size).to eq(4)

      expect(result)
        .to all(include(
          "tier" => be_an(Integer),
          "user" => include(
            "id" => be_an(Integer),
            "name" => a_string_matching(/^Test\d+$/),
            "avatar_url" => a_string_matching(%r{https://cdn.discordapp.com/avatars/\d+/[0-9a-f]+\.png}),
            "discriminator" => a_string_matching(/\d{4}/)
          )
        ))
    end
  end
end
