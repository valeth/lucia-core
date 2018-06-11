# frozen_string_literal: true

class LuciController < ApplicationController
  SERVICES = %i[
    sigma
    sigmamusic
    apdata
    nginx
    mongod
  ].freeze

  def show
    @services = SERVICES
      .map { |s| ServiceStatus.new(s) }
      .select(&:available?)
  end
end
