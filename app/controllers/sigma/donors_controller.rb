module Sigma
  class DonorsController < ApplicationController
    def index
      @donors = Donor.all.sort(tier: -1)
    end
  end
end
