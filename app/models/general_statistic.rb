# frozen_string_literal: true

class GeneralStatistic
  include Mongoid::Document

  store_in client: "sigma", collection: "GeneralStats"

  field :name, type: String
  field :guild_count, type: Integer
  field :channel_count, type: Integer
  field :member_count, type: Integer
end
