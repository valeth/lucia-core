Rails.application.routes.draw do
  concern :rest_v1 do
    namespace :sigma do
      resources "commands",   only: %i[index]
      resources "donors",     only: %i[index]
      resources "stats",      only: %i[index]
      resource "leaderboard", only: %i[show]
      get "version" => "version#show"
    end

    scope :luci do
      get "status" => "luci#show"
    end

    scope :bus do
      get 'times' => "busplus#show"
    end
  end

  scope :rest do
    concerns :rest_v1

    scope :v1 do
      concerns :rest_v1
    end
  end
end
