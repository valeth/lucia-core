# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::LuciaCoreSchema do
  describe ".execute" do
    it "can query bot information" do
      result = described_class.execute <<~GRAPHQL
        query {
          sigma {
            info {
              beta
              buildDate
              codename
              version { major minor patch }
            }
          }
        }
      GRAPHQL

      expect(result["data"])
        .to include(
          "sigma" => include(
            "info" => include(
              "beta" => true,
              "buildDate" => be_an(Integer),
              "codename" => be_a(String),
              "version" => include(
                "major" => be_an(Integer),
                "minor" => be_an(Integer),
                "patch" => be_an(Integer)
              )
            )
          )
        )
    end

    it "can query bot modules and commands" do
      result = described_class.execute <<~GRAPHQL
        query {
          sigma {
            commandCategories {
              name
              commands { name }
            }
          }
        }
      GRAPHQL

      expect(result["data"])
        .to include(
          "sigma" => include(
            "commandCategories" => all(include(
              "name" => be_a(String),
              "commands" => all(include(
                "name" => be_a(String)
              ))
            ))
          )
        )
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
          "donors" => all(include(
            "name" => a_string_matching(/^Test\d+$/)
          ))
        )
    end
  end
end
