# frozen_string_literal: true

require_dependency "discord_user_fetcher"

class DiscordUser
  attr_reader :id
  attr_reader :discriminator

  def initialize(uid, data, **options)
    @id = uid
    @name = data["username"]
    @discriminator = data["discriminator"]
    @avatar_id = data["avatar"]
    @fallbacks = {
      avatar_url: options.fetch(:fallback_avatar_url, "https://i.imgur.com/QnYSlld.png"),
      name: options.fetch(:fallback_name, "{Unknown}")
    }
  end

  def avatar_url
    if @avatar_id
      ext = @avatar_id.start_with?("a_") ? ".gif" : ".png"
      "https://cdn.discordapp.com/avatars/#{id}/#{@avatar_id}#{ext}"
    else
      @fallbacks[:avatar_url]
    end
  end

  def name
    @name || @fallbacks[:name]
  end

  def to_h
    { id: @id, name: @name, discriminator: @discriminator, avatar_url: avatar_url }
  end

  class << self
    def get(uid, **options)
      user_data = fetch_user_data(uid, cached: options.fetch(:cached, true))
      new(uid, user_data, **options)
    end

    alias [] get

  private

    def fetch_user_data(uid, cached: true)
      expiration = Rails.env.development? ? 5.seconds : 5.minutes
      fetcher = proc { DiscordUserFetcher.fetch(uid) }
      if cached
        Rails.cache.fetch("#{uid}-discord-user", expires_in: expiration, &fetcher)
      else
        fetcher.call
      end
    end
  end
end
