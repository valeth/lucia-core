# frozen_string_literal: true

module Score
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document

    field :user_id, as: :uid, type: Integer
    field :ranked, as: :score, type: Integer, default: 0
    field :origins, type: Hash, default: { "users": {}, "guilds": {}, "channels": {} }

    # @return Integer
    def tier
      (score / 100).to_i
    end

    # @return Integer
    def current_level
      (score / leveler).to_i
    end

    # @return Integer
    def next_level_required
      ((current_level + 1) * leveler).to_i
    end

    # @return String
    def title
      level = current_level
      prefix = prefixes[(level % 100) / prefixes.size]
      suffix = suffixes[(level % 100) % suffixes.size]
      [prefix, suffix].join(" ")
    end

    # @return Integer
    def next_level_percent
      req = (((leveler - (next_level_required - score)) / leveler) * 100).round(2)
      req != score ? req : req + 1
    end

    # @return DiscordUser
    def user
      Discord::User[uid]
    end

  private

    def prefixes
      self.class.instance_variable_get(:@prefixes) || []
    end

    def suffixes
      self.class.instance_variable_get(:@suffixes) || []
    end

    def leveler
      self.class.instance_variable_get(:@leveler) || 1.0
    end
  end

  class_methods do
    def by_guild_id(gid, amount: 20)
      where(:"origins.guilds.#{gid}".exists => true)
        .limit(amount)
        .desc(:score)
    end

    def get(amount: 20)
      all.limit(amount).desc(:score)
    end

  private

    attr_writer :prefixes
    attr_writer :suffixes
    attr_writer :leveler
  end
end
