module Types::Sigma
  class StatsSetType < Types::BaseObject
    field :commands, [Types::Sigma::StatsEntryType], null: false do
      argument :only, [String], required: false
      argument :except, [String], required: false
    end

    field :events, [Types::Sigma::StatsEntryType], null: false do
      argument :only, [String], required: false
      argument :except, [String], required: false
    end

    field :special, [Types::Sigma::StatsEntryType], null: false

    field :guild_count, Integer, null: false
    field :channel_count, Integer, null: false
    field :member_count, Integer, null: false
    field :command_count, Integer, null: false

    def commands(only: [], except: [])
      if only.empty? && except.empty?
        CommandStatistic.all
      elsif only.empty?
        CommandStatistic.filtered(except: except)
      else
        CommandStatistic.filtered(only: only)
      end
    end

    def events(only: [], except: [])
      if only.empty? && except.empty?
        EventStatistic.all
      elsif only.empty?
        EventStatistic.filtered(except: except)
      else
        EventStatistic.filtered(only: only)
      end
    end

    def special
      SpecialStatistic.all
    end

    def guild_count
      GeneralStatistic.total_guilds
    end

    def channel_count
      GeneralStatistic.total_channels
    end

    def member_count
      GeneralStatistic.total_members
    end

    def command_count
      CommandStatistic.total_commands_executed
    end
  end
end
