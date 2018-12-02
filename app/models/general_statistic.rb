# frozen_string_literal: true

require "ostruct"

class GeneralStatistic
  include Mongoid::Document

  store_in client: "sigma", collection: "GeneralStats"

  field :name, type: String
  field :guild_count, type: Integer
  field :channel_count, type: Integer
  field :member_count, type: Integer

  def sum
    tmp = where(name: :population)
          .reduce(guild_count: 0, channel_count: 0, member_count: 0) do |acc, item|
            [acc[:guild_count] + item.guild_count,
             acc[:channel_count] + item.channel_count,
             acc[:member_count] + item.member_count]
          end
    OpenStruct.new(tmp)
  end
end
