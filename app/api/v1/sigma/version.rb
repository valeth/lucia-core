# frozen_string_literal: true

class V1::Sigma::Version < Grape::API
  namespace :version do
    get do
      version = BotVersion.first
      present version, with: ::Entities::BotVersion
    end
  end
end
