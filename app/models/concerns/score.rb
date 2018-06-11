# frozen_string_literal: true

module Score
  extend ActiveSupport::Concern

  included do
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
      prefix = prefixes[(level % 100) / suffixes.size]
      suffix = suffixes[(level % 100) % suffixes.size]
      "#{prefix} #{suffix}"
    end

    # @return Integer
    def next_level_percent
      req = (((leveler - (next_level_required - score)) / leveler) * 100).round(2)
      req != score ? req : req + 1
    end

    # @return User
    def user_data
      DiscordUser.cached_data(uid).make_data
    end
  end
end
