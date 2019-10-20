# frozen_string_literal: true

require "rails_helper"

RSpec.describe ::LuciaCoreSchema do
  context "query" do
    describe "donors" do
      it "can query all names of donors" do
        result = described_class.execute <<~GRAPHQL
          query {
            donors { name }
          }
        GRAPHQL

        expect(result["data"])
          .to include(
            "donors" => all(include(
              "name" => a_string_matching(/^Test\d+$/)
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
              cookies: leaderboard(type: "COOKIES") {
                ...leaderboardItems
              }
              currency: leaderboard(type: "CURRENCY") {
                ...leaderboardItems
              }
            }
          }

          fragment leaderboardItems on LeaderboardEntry {
            currentLevel
            tier
          }
        GRAPHQL

        expect(result["data"])
          .to include(
            "sigma" => include(
              "cookies" => all(include(
                "tier" => be_an(Integer),
                "currentLevel" => be_an(Integer)
              )),
              "currency" => all(include(
                "tier" => be_an(Integer),
                "currentLevel" => be_an(Integer)
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
                "commands" => all(include("name" => be_a(String), "count" => be_a(Integer))),
                "events" => all(include("name" => be_a(String), "count" => be_a(Integer))),
                "special" => all(include("name" => be_a(String), "count" => be_a(Integer))),
                "commandCount" => be_a(Integer),
                "guildCount" => be_a(Integer),
                "channelCount" => be_a(Integer),
                "memberCount" => be_a(Integer),
              )
            )
          )
      end
    end
  end
end
