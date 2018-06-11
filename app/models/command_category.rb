# frozen_string_literal: true

class CommandCategory
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

  attr_reader :commands

  def initialize(name, cat)
    @name = name.to_sym
    @commands = cat.reduce([]) do |acc, mod|
      cmds = mod.fetch("commands", [])
      acc + cmds.map { |cmd| Command.new(cmd, name) }
    end
  end

  def name
    @name.to_s.titleize
  end

  def commands_available?
    @commands.present?
  end

  def icon
    ICONS[@name]
  end

  def filter_commands(criteria)
    return self unless criteria.respond_to?(:to_h)
    filtered = self.class.new(@name, [])
    filtered_commands = @commands.select do |cmd|
      cmd.matches?(criteria.to_h.symbolize_keys)
    end
    filtered.instance_variable_set(:@commands, filtered_commands)
    filtered
  end
end
