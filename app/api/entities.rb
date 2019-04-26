# frozen_string_literal: true

module Entities
  class BotVersion < Grape::Entity
    expose :beta
    expose :build_date
    expose :codename
    expose :version
  end

  class BotCommand < Grape::Entity
    expose :admin
    expose :partner
    expose :usage
    expose :names do
      expose :name, as: :primary
      expose :alts
    end
    expose :category do |cmd|
      cmd.category.name
    end
    expose :desc do |cmd|
      cmd.desc || "No description"
    end
    expose :sfw do |cmd|
      !cmd.nsfw
    end
  end

  class BotCommandCategory < Grape::Entity
    format_with :titleize do |title|
      title.titleize
    end

    expose :name, format_with: :titleize
    expose :icon
    expose :commands, using: BotCommand
  end

  class Donor < Grape::Entity
    expose :name
    expose :duid
    expose :tier
    expose :avatar
  end

  class Score < Grape::Entity
    expose :user_data, as: :user
    expose :score, as: :value
    expose :level do
      expose :current_level, as: :curr
      expose :next_level_required, as: :next_req
      expose :next_level_percent, as: :next_perc
    end
    expose :title do
      expose :tier
      expose :title, as: :name
    end
  end

  class Stats < Grape::Entity
    expose :commands do |stats|
      stats[:commands].each_with_object({}) { |c, acc| acc[c.command] = c.count }
    end
    expose :events do |stats|
      stats[:events].each_with_object({}) { |e, acc| acc[e.name] = e.count }
    end
    expose :general do
      expose :population do
        expose :guild_count do |stats|
          stats[:general].guild_count
        end
        expose :member_count do |stats|
          stats[:general].member_count
        end
        expose :channel_count do |stats|
          stats[:general].channel_count
        end
      end
      expose :cmd_count do |stats|
        stats[:commands].sum(&:count)
      end
    end
    expose :special do |stats|
      stats[:special].each_with_object({}) { |s, acc| acc[s.name] = s.count }
    end
  end
end
