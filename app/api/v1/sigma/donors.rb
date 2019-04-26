# frozen_string_literal: true

class V1::Sigma::Donors < Grape::API
  namespace :donors do
    get do
      donors = Donors.all.sort(tier: -1)
      present donors, with: ::Entities::Donor
    end
  end
end
