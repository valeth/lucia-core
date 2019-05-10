# frozen_string_literal: true

require "ostruct"

class GeneralStatistic
  include Mongoid::Document

  store_in collection: "GeneralStats"

  field :name, type: String
  field :guild_count, type: Integer
  field :channel_count, type: Integer
  field :member_count, type: Integer

  # rubocop:disable Style/MultilineBlockChain
  def self.collect_stats
    where(name: :population)
      .each_with_object(guild_count: 0, channel_count: 0, member_count: 0) do |item, acc|
        acc[:guild_count] += item.guild_count if item.guild_count
        acc[:channel_count] += item.channel_count if item.channel_count
        acc[:member_count] += item.member_count if item.member_count
      end
      .then { |obj| OpenStruct.new(obj) }
  end
  # rubocop:enable Style/MultilineBlockChain
end
