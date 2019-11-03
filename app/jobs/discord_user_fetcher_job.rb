# frozen_string_literal: true

class DiscordUserFetcherJob < ApplicationJob
  discard_on Discord::APIError do |job, err|
    logger.error(err.message)
  end

  def perform(id, *args)
    user = Discord::User.fetch(id, use_cache: false)
    Discord::API.set_cache(user)
  end
end
