# frozen_string_literal: true

class Leaderboard
  @resources = {}

  def user
    Discord::User.try_cache(uid) || Discord::User.new(id: uid)
  end

  def user_sabotaged?
    SabotagedUser.where(uid:).exists?
  end

  def user_blacklisted?
    BlacklistedUser.where(uid:, total: true).exists?
  end

  class << self
    def [](name)
      @resources[name.to_sym] ||= Class.new(self) do
        include Mongoid::Document

        field :user_id, as: :uid, type: Integer
        field :ranked, as: :score, type: Integer, default: 0
        field :origins, type: Hash, default: { "users": {}, "guilds": {}, "channels": {} }
        field :expenses, type: Hash, default: { "users": {}, "guilds": {}, "channels": {} }

        store_in collection: "#{name.to_s.downcase.camelize}Resource"
      end
    end

    # Gets top user IDs from every leaderboard.
    #
    # @param amount [Integer] The amount of users to fetch per board
    # @return [Array<Integer>] Unique list of IDs
    def top_user_ids(amount: 30)
      Mongoid
        .client(:default)
        .collections
        .each_with_object([]) { |c, a| a << c.name.delete_suffix("Resource") if c.name.end_with?("Resource") }
        .flat_map { |x| Leaderboard[x].get_sorted.limit(amount) }
        .pluck(:uid)
        .uniq
    end

    def by_guild_id(gid, amount: 20)
      get_sorted
        .where(:"origins.guilds.#{gid}".exists => true)
        .limit(amount)
    end

    def get(amount: 20)
      get_sorted.limit(amount)
    end

    def get_sorted
      nin(uid: BlacklistedUser.pluck(:uid))
        .union
        .nin(uid: SabotagedUser.pluck(:uid))
        .desc(:score)
    end
  end
end
