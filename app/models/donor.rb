class Donor
  include Mongoid::Document

  store_in client: "sigma", collection: "DonorCache"

  field :duid, type: Integer
  field :tier, type: Integer
  field :name, as: :fallback_name, type: String
  field :avatar, as: :fallback_avatar, type: String

  def avatar
    user.avatar_url(fallback: fallback_avatar)
  end

  def name
    user.name(fallback: fallback_name)
  end

private

  def user
    DiscordUser.cached_data(duid)
  end
end
