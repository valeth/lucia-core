# frozen_string_literal: true

class LuciController < ApplicationController
  SERVICES = %i[
    sigma
    sigmamusic
    lucia-core
    nginx
    mongod
  ].freeze

  def show
    @services = SERVICES
                .map { |s| ServiceStatus.new(s) }
                .select(&:available?)
  end
end
