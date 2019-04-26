# frozen_string_literal: true

class API < Grape::API
  format :json
  prefix :rest

  version "v1", using: :path do
    mount ::V1::Sigma
  end

  mount ::V1::Sigma

  get do
    API::routes.map(&:namespace).uniq
  end

  # Catch all non-matching routes on this API endpoint
  route :any, "*path" do
    error!("Not found", 404)
  end
end
