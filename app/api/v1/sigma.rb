# frozen_string_literal: true

class API::V1::Sigma < Grape::API
  namespace :sigma do
    mount Commands
    mount Donors
    mount Leaderboard
    mount Stats
    mount Version

    get do
      Sigma::routes.map(&:namespace).uniq
    end
  end
end
