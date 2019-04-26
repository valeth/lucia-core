require "rails_helper"

RSpec.describe ::API::V1::Sigma::Version do
  before do
    BotVersion.find_or_create_by(build_date: 1556274480) do |m|
      m.beta = true
      m.codename = "Vueko"
      m.version = { major: 4, minor: 1, patch: 666 }
    end
  end

  context "GET /rest/v1/sigma/version" do
    it "returns version information for the Sigma Discord bot" do
      get "/rest/v1/sigma/version"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({
        "beta" => true,
        "build_date" => 1556274480,
        "codename" => "Vueko",
        "version" => {
          "major" => 4,
          "minor" => 1,
          "patch" => 666
        }
      })
    end
  end
end
