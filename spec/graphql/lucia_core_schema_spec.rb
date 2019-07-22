# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::LuciaCoreSchema do
  describe ".execute" do
    it "can query bot information" do
      query = <<~GRAPHQL
        query {
          sigma {
            info {
              codename
              beta
              buildDate
              version { major minor patch }
            }
          }
        }
      GRAPHQL

      expected_result = {
        "sigma" => {
          "info" => {
            "codename" => "Vueko",
            "beta" => true,
            "buildDate" => 1556274480,
            "version" => {
              "major" => 4,
              "minor" => 1,
              "patch" => 666
            }
          }
        }
      }

      result = described_class.execute(query)
      expect(result["data"]).to eq(expected_result)
    end

    it "can query bot modules and commands" do
      query = <<~GRAPHQL
        query {
          sigma {
            modules {
              name
              commands { name }
            }
          }
        }
      GRAPHQL

      expected_result = {
        "sigma" => {
          "modules" => [
            {
              "name" => "test",
              "commands" => [
                { "name" => "hello" },
                { "name" => "help" }
              ]
            }
          ]
        }
      }

      result = described_class.execute(query)
      expect(result["data"]).to eq(expected_result)
    end

    it "can query names of donors" do
      query = <<~GRAPHQL
        query {
          donors { name }
        }
      GRAPHQL

      expected_result = {
        "donors" => [
          { "name" => "Test217078934976724992" }
        ]
      }

      result = described_class.execute(query)
      expect(result["data"]).to eq(expected_result)
    end
  end
end
