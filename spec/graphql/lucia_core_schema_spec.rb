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
            commandCategories {
              name
              commands { name }
            }
          }
        }
      GRAPHQL

      expected_result = {
        "sigma" => {
          "commandCategories" => [
            {
              "name" => "test",
              "commands" => [
                { "name" => "hello" }
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

      result = described_class.execute(query)
      expect(result["data"])
        .to include(
          "donors" => all(include("name" => a_string_matching(/^Test\d+$/)))
        )
    end
  end
end
