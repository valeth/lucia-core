require "rails_helper"

RSpec.describe ::API::V1::Sigma::Commands do
  context "GET /rest/v1/sigma/commands" do
    it "returns a categorized list of commands" do
      get "/rest/v1/sigma/commands"
      result = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(result).to all(include(
        "name" => be_a(String),
        "icon" => be_nil,
        "commands" => all(include(
          "admin" => be_boolean,
          "partner" => be_boolean,
          "usage" => a_string_matching(/^>>\w+$/),
          "names" => include(
            "primary" => be_a(String),
            "alts" => be_an(Array)
          ),
          "category" => be_a(String),
          "desc" => be_a(String),
          "sfw" => be_boolean
        ))
      ))
    end

    it "can be filtered by name" do
      get "/rest/v1/sigma/commands?filter[name]=hell"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      commands = result.first["commands"]
      expect(commands.size).to eq(1)
      expect(commands.dig(0, "names", "primary")).to eq("hello")
    end

    it "can be filtered by description" do
      get "/rest/v1/sigma/commands?filter[desc]=fall"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      commands = result.first["commands"]
      expect(commands.size).to eq(1)
      expect(commands.dig(0, "names", "primary")).to eq("help")
    end

    it "can combine name and description filters" do
      get "/rest/v1/sigma/commands?filter[name]=he&filter[desc]=not"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      commands = result.first["commands"]
      expect(commands.size).to eq(1)
      expect(commands.dig(0, "names", "primary")).to eq("hello")
    end
  end
end
