# frozen_string_literal: true

class API::V1::Sigma::Version < Grape::API
  namespace :version do
    before do
      header "Cache-Control", "public,max-age=3600,must-revalidate"
    end

    get do
      version = BotVersion.first
      present version, with: ::Entities::BotVersion
    end
  end
end
