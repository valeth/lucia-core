# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::LuciaCoreSchema do
  context "query" do
    describe "donors" do
      it "can query all names of donors" do
        result = described_class.execute <<~GRAPHQL
          query {
            donors {
              tier
              user { name }
            }
          }
        GRAPHQL

        expect(result["data"])
          .to include(
            "donors" => all(include(
              "tier" => be_an(Integer),
              "user" => include(
                "name" => a_string_matching(/^Test\d+$/)
              )
            ))
          )
      end
    end

    describe "sigma" do
      it "can query all bot information" do
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

      it "can query all command categories with commands" do
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

      it "can query all leaderboards" do
        result = described_class.execute <<~GRAPHQL
          query {
            sigma {
              cookies: leaderboard(type: "COOKIES") { score }
              currency: leaderboard(type: "CURRENCY") { score }
            }
          }
        GRAPHQL

        expect(result["data"])
          .to include(
            "sigma" => include(
              "cookies" => all(include(
                "score" => be_an(Integer),
              )),
              "currency" => all(include(
                "score" => be_an(Integer),
              ))
            )
          )
      end

      it "can query all statistics" do
        result = described_class.execute <<~GRAPHQL
          query {
            sigma {
              stats {
                commands { name count }
                events { name count }
                special { name count }
                commandCount
                guildCount
                channelCount
                memberCount
              }
            }
          }
        GRAPHQL

        expect(result["data"])
          .to include(
            "sigma" => include(
              "stats" => include(
                "commands" => all(include("name" => be_a(String), "count" => be_a(String))),
                "events" => all(include("name" => be_a(String), "count" => be_a(String))),
                "special" => all(include("name" => be_a(String), "count" => be_a(String))),
                "commandCount" => be_a(String),
                "guildCount" => be_a(String),
                "channelCount" => be_a(String),
                "memberCount" => be_a(String),
              )
            )
          )
      end
    end

    it "can filter command statistics" do
      result = described_class.execute <<~GRAPHQL
        query {
          sigma {
            stats {
              commands(only: ["hunt"]) { name }
              events(only: ["ready"]) { name }
            }
          }
        }
      GRAPHQL

      expect(result["data"])
        .to eq(
          "sigma" => {
            "stats" => {
              "commands" => [{ "name" => "hunt" }],
              "events" => [{ "name" => "ready" }]
            }
          }
        )

      result = described_class.execute <<~GRAPHQL
        query {
          sigma {
            stats {
              commands(except: ["hunt", "fish"]) { name }
              events(except: ["ready", "dbinit"]) { name }
            }
          }
        }
      GRAPHQL

      expect(result["data"])
        .to eq(
          "sigma" => {
            "stats" => {
              "commands" => [{ "name" => "givecookie" }],
              "events" => [{ "name" => "command" }]
            }
          }
        )
    end
  end
end
