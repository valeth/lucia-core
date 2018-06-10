class Donor
  attr_reader :tier
  attr_reader :duid

  def initialize(donor)
    @duid = donor["duid"]
    @tier = donor["tier"]
    @fallback_avatar = donor["avatar"]
    @fallback_name = donor["name"]
  end

  def avatar
    user.avatar_url(fallback: @fallback_avatar)
  end

  def name
    user.name(fallback: @fallback_name)
  end

private

  def user
    DiscordUser.cached_data(@duid)
  end
end
