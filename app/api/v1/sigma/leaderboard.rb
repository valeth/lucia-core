# frozen_string_literal: true

class V1::Sigma::Leaderboard < Grape::API
  helpers do
    def list_scores
      resource =
        case params[:kind]
        when "currency" then CurrencySystem
        when "experience" then ExperienceSystem
        when "cookies" then Cookie
        end
      scores = resource.all.desc(:score).limit(20)
      present scores, with: ::Entities::Score
    end
  end

  namespace :leaderboards do
    params do
      requires :kind, type: String, values: %w[cookies currency experience]
    end

    get ":kind" do
      list_scores
    end
  end
end
