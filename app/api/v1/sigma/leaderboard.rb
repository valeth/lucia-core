# frozen_string_literal: true

class API::V1::Sigma::Leaderboard < Grape::API
  helpers do
    def list_scores
      resource =
        case params[:kind]
        when "currency" then CurrencySystem
        when "experience" then ExperienceSystem
        when "cookies" then Cookie
        end
      scores = if params[:filter]
        filter = params[:filter]
        resource
          .where(:"origins.guilds.#{filter[:guild_id]}".exists => true)
          .limit(20)
          .desc(:score)
      else
        resource.all.limit(20).desc(:score)
      end
      present scores, with: ::Entities::Score
    end
  end

  namespace :leaderboards do
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
      list_scores
    end
  end
end
