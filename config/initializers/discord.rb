# frozen_string_literal: true

require "discord/api"

Discord::API.configure do |config|
  config.token = ENV.fetch("DISCORD_BOT_TOKEN")
  config.logger = Rails.logger
  config.cache = Rails.cache
  config.cache_duration = Rails.env.development? ? 30.seconds : 5.minutes
end
