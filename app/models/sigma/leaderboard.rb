# frozen_string_literal: true

class Leaderboard
  @resources = {}

  def user
    Discord::User.try_cache(uid) || Discord::User.new(id: uid)
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

    def all
      Mongoid
        .client(:default)
        .collections
        .each_with_object([]) { |c, a| a << c.name.delete_suffix("Resource") if c.name.end_with?("Resource") }
        .flat_map { |x| Leaderboard[x].all }
    end

    # Gets all user IDs from every leaderboard.
    #
    # @return [Array<Integer>] Unique list of IDs
    def all_user_ids
      all.pluck(:uid).uniq
    end

    def by_guild_id(gid, amount: 20)
      where(:"origins.guilds.#{gid}".exists => true)
        .limit(amount)
        .desc(:score)
    end

    def get(amount: 20)
      all.limit(amount).desc(:score)
    end
  end
end
