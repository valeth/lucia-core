# frozen_string_literal: true

class API::V1::Sigma::Donors < Grape::API
  namespace :donors do
    before do
      header "Cache-Control", "public,max-age=3600,must-revalidate"
    end

    get do
      donors = Donor.all.desc(:tier)
      present donors, with: ::Entities::Donor
    end
  end
end
