module Sigma
  class DonorsController < ApplicationController
    DonorsError = Class.new(StandardError)

    rescue_from DonorsError do |e|
      render json: { error: e.message }, status: 500
    end

    def index
      @donors = donors_list.sort_by(&:tier).reverse
    end

  private

    # @return Array<Donor>
    def donors_list
      yml = Rails.configuration.x.sigma_path.join("info/donors.yml")
      raise DonorsError, "Donors file not found" unless yml.exist?
      YAML.safe_load(yml.read).fetch("donors", []).map { |d| Donor.new(d) }
    rescue SystemCallError, YAML::Exception
      raise DonorsError, "Failed to read donors file."
    end
  end
end
