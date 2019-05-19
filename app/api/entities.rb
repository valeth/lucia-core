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
    format_with(:titleize, &:titleize)

    expose :name, format_with: :titleize
    expose :icon
    expose :commands, using: BotCommand
  end

  class DiscordUser < Grape::Entity
    expose :name
    expose :discriminator
    expose :id
    expose :avatar_url
  end

  class Donor < Grape::Entity
    expose :tier
    expose :user, using: DiscordUser
  end

  class Score < Grape::Entity
    expose :user, using: DiscordUser
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

  class GeneralStats < Grape::Entity
    expose :population do
      expose :guild_count
      expose :member_count
      expose :channel_count
    end
    expose(:cmd_count, &:command_count)
  end

  class Stats < Grape::Entity
    expose :commands do |stats|
      ::Entities.list_formatter(stats[:commands])
    end
    expose :events do |stats|
      ::Entities.list_formatter(stats[:events])
    end
    expose :general, using: GeneralStats
    expose :special do |stats|
      ::Entities.list_formatter(stats[:special])
    end
  end

module_function

  def list_formatter(list)
    list.each_with_object({}) do |item, acc|
      next unless item.respond_to?(:to_list_entry)

      acc.update(item.to_list_entry)
    end
  end
end
