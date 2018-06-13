# frozen_string_literal: true

class CommandCategory
  include Mongoid::Document

  ICONS = {
    music: "music",
    minigames: "target",
    roles: "tag",
    fun: "sun",
    development: "gh",
    utility: "command",
    games: "crosshair",
    shop: "credit-card",
    moderation: "shield",
    points: "award",
    interactions: "at-sign",
    nihongo: "book",
    searches: "search",
    nsfw: "moon",
    help: "info",
    permissions: "lock",
    settings: "cog",
    patreon: "patreon",
    statistics: "bar-chart-2",
    mathematics: "hash",
    miscellaneous: "command",
    logging: "shield",
    league_of_legends: "league",
    path_of_exile: "sword",
    overwatch: "overwatch",
    warframe: "warframe",
    osu: "osu"
  }.freeze

  store_in client: "sigma", collection: "ModuleCache"

  field :name, type: String
  has_many :commands, class_name: "Command", dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def icon
    ICONS[name&.to_sym]
  end

  def commands_available?
    commands.present?
  end

  def filter_commands(criteria)
    return self unless criteria.respond_to?(:to_h)
    self.class.new(name: self[:name]).tap do |cat|
      cat.commands = commands.select do |cmd|
        cmd.matches?(criteria.to_h.symbolize_keys)
      end
    end
  end
end
