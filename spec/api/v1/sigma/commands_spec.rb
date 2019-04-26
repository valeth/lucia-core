require "rails_helper"

RSpec.describe ::API::V1::Sigma::Commands do
  context "GET /rest/v1/sigma/commands" do
    before do
      cat = CommandCategory.find_or_create_by(name: "test")
      cat.commands << Command.find_or_create_by(name: "hello") do |c|
        c.desc = "Nothing"
        c.nsfw = false
        c.partner = false
        c.admin = false
      end
      cat.commands << Command.find_or_create_by(name: "help") do |c|
        c.desc = "I've fallen"
        c.nsfw = true
        c.partner = false
        c.admin = true
      end
    end

    it "returns a categorized list of commands" do
      get "/rest/v1/sigma/commands"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body)
      expect(result).to eq [{
        "name" => "Test",
        "icon" => nil,
        "commands" => [{
          "admin" => false,
          "partner" => false,
          "usage" => ">>hello",
          "names" => { "primary" => "hello", "alts" => [] },
          "category" => "test",
          "desc" => "Nothing",
          "sfw" => true
        }, {
          "admin" => true,
          "partner" => false,
          "usage" => ">>help",
          "names" => { "primary" => "help", "alts" => [] },
          "category" => "test",
          "desc" => "I've fallen",
          "sfw" => false
        }]
      }]
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
