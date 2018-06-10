# frozen_string_literal: true

class DiscordUser
  include Mongoid::Document

  store_in collection: "Users"

  field :UserID, as: :uid, type: Integer
  field :Data, as: :data, type: Hash, default: {}
  field :Time, as: :timestamp, type: Time, default: -> { Time.now }

  def self.cached_data(uid)
    cached_user = where(uid: uid).first

    if !cached_user || cached_user.cache_expired?
      user_data = DiscordUserFetcher.fetch(uid)
      cache_data = { uid: uid, data: user_data, timestamp: Time.now }
      if cached_user
        where(uid: uid).update(cache_data)
        where(uid: uid).first
      else
        where(cache_data).create
      end
    else
      Rails.logger.debug { "#{self} | Cache hit for #{uid}" }
      cached_user
    end
  end

  def cache_expired?
    timestamp.next_day < Time.now
  end

  def avatar_url(fallback: "https://i.imgur.com/QnYSlld.png")
    aid = data["avatar"]
    if aid
      ext = aid.start_with?("a_") ? ".gif" : ".png"
      "https://cdn.discordapp.com/avatars/#{uid}/#{aid}#{ext}"
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
    { Name: name, Discriminator: discriminator, UserID: uid, Avatar: avatar_url }
  end
end
