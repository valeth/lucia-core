# frozen_string_literal: true

class API < Grape::API
  format :json
  prefix :rest

  before do
    header "Cache-Control", "public,max-age=0,must-revalidate"
  end

  version "v1", using: :path do
    mount ::API::V1::Sigma
  end

  mount ::API::V1::Sigma

  get do
    API::routes.map(&:namespace).uniq
  end

  # Catch all non-matching routes on this API endpoint
  route :any, "*path" do
    error!("Not found", 404)
  end
end
