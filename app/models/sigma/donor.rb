class Donor
  include Mongoid::Document

  store_in collection: "DonorCache"

  field :duid, type: Integer
  field :tier, type: Integer
  field :name, as: :fallback_name, type: String
  field :avatar, as: :fallback_avatar, type: String

  def user
    Discord::User.try_cache(duid) || Discord::User.new(id: duid, avatar_url: fallback_avatar, name: fallback_name)
  end

  class << self
    # Gets all user IDs of donors.
    #
    # @return [Array<Integer>] Unique list of IDs
    def all_user_ids
      pluck(:duid).uniq
    end
  end
end
