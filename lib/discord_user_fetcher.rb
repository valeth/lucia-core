# frozen_string_literal: true

require_dependency "rest-client"
require_dependency "json"

module DiscordUserFetcher
  BASE_URL = "https://discordapp.com/api/"

module_function

  def fetch(uid)
    url = "#{BASE_URL}/users/#{uid}"
    token = Rails.application.secrets.discord_bot_token
    Rails.logger.debug { "#{self} | Fetching user data for #{uid}" }
    user_data = RestClient.get(url, Authorization: "Bot #{token}")
    JSON.parse(user_data)
  rescue ExceptionWithResponse, JSON::ParserError
    nil
  end
end
