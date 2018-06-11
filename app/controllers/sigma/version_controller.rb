module Sigma
  class VersionController < ApplicationController
    VersionError = Class.new(StandardError)

    rescue_from VersionError do |e|
      render json: { error: e.message }, status: 500
    end

    def show
      render json: version
    end

  private

    def version
      yml = Rails.configuration.x.sigma_path.join("info/version.yml")
      raise VersionError, "Version filed not found" unless yml.exist?
      YAML.safe_load(yml.read)
    rescue SystemCallError, YAML::Exception
      raise VersionError, "Failed to read version file"
    end
  end
end
