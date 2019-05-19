class Donor
  include Mongoid::Document

  store_in collection: "DonorCache"

  field :duid, type: Integer
  field :tier, type: Integer
  field :name, as: :fallback_name, type: String
  field :avatar, as: :fallback_avatar, type: String

  def user
    @user ||= Discord::User
      .get(duid, fallback_avatar_url: fallback_avatar, fallback_name: fallback_name)
  end
end
