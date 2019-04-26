# frozen_string_literal: true

class API::V1::Sigma::Donors < Grape::API
  namespace :donors do
    get do
      donors = Donor.all.desc(:tier)
      present donors, with: ::Entities::Donor
    end
  end
end
