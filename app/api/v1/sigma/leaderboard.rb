# frozen_string_literal: true

class API::V1::Sigma::Leaderboard < Grape::API
  SCOREBOARDS = {
    "currency" => CurrencySystem,
    "experience" => ExperienceSystem,
    "cookies" => Cookie
  }.freeze

  namespace :leaderboard do
    params do
      requires :kind, type: String, values: %w[cookies currency experience]
      optional :filter, type: Hash, allow_blank: false
      given :filter do
        optional :filter, type: Hash do
          requires :guild_id, type: Integer, allow_blank: false
        end
      end
    end

    get ":kind" do
      resource = SCOREBOARDS[params[:kind]]
      gid = params.dig(:filter, :guild_id)
      scores = gid ? resource.by_guild_id(gid) : resource.get
      present scores, with: ::Entities::Score
    end
  end
end
