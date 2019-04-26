# frozen_string_literal: true

require_dependency "discord_user_fetcher"

class DiscordUser
  attr_accessor :id
  attr_accessor :data

  def initialize(uid, data)
    @id = uid
    @data = data
  end

  def self.cached_data(uid)
    data = Rails.cache.fetch("#{uid}-discord-user", expires_in: 5.minutes) do
      DiscordUserFetcher.fetch(uid)
    end

    new(uid, data)
  end

  def avatar_url(fallback: "https://i.imgur.com/QnYSlld.png")
    aid = data["avatar"]
    if aid
      ext = aid.start_with?("a_") ? ".gif" : ".png"
      "https://cdn.discordapp.com/avatars/#{id}/#{aid}#{ext}"
    else
      fallback
    end
  end

  def discriminator
    data.fetch("discriminator", nil)
  end

  def name(fallback: "{Unknown}")
    data.fetch("username", fallback)
  end

  def make_data
    { Name: name, Discriminator: discriminator, UserID: id, Avatar: avatar_url }
  end
end
