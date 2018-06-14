# frozen_string_literal: true

require_dependency "socket" if /.*-linux/.match?(RUBY_PLATFORM)
require_dependency "json"
require_dependency "objectified_hash"

class LuciController < ApplicationController
  ServiceInfoError = Class.new(StandardError)

  rescue_from ServiceInfoError do |e|
    render json: { error: e.message }, status: 500
  end

  SERVICES = %i[
    sigma
    sigmamusic
    lucia-core
    nginx
    mongod
  ].freeze

  def show
    @services = service_info
  end

private

  def service_info
    return [] unless /.*-linux/.match?(RUBY_PLATFORM)
    tries = 3
    begin
      @socket ||= UNIXSocket.new(Rails.configuration.x.systemd_info_socket)
      SERVICES.map do |service|
        @socket.puts(service)
        data = @socket.gets
        ObjectifiedHash.new(JSON.parse(data))
      end
    rescue Errno::EPIPE
      @socket&.close
      @socket = nil
      tries -= 1
      retry unless tries.zero?
      raise ServiceInfoError
    end
  rescue ServiceInfoError, Errno::ENOENT
    raise ServiceInfoError, "Could not fetch service info."
  end
end
