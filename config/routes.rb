Rails.application.routes.draw do
  concern :rest_v1 do
    defaults format: :json do
      namespace :sigma do
        resources "commands", only: %i[index]
        resources "donors", only: %i[index]
        resources "stats", only: %i[index]
        resources "leaderboards", only: %i[show]
        get "leaderboard/:id", to: "leaderboards#show"
        get "version", to: "version#show"
      end

      scope :luci do
        get "status", to: "luci#show"
      end
    end
  end

  scope :rest do
    concerns :rest_v1

    scope :v1 do
      concerns :rest_v1
    end
  end
end
