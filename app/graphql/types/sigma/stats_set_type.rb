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

    field :special, [Types::Sigma::StatsEntryType], null: false do
      argument :only, [String], required: false
      argument :except, [String], required: false
    end

    field :guild_count, Integer, null: false
    field :channel_count, Integer, null: false
    field :member_count, Integer, null: false
    field :command_count, Integer, null: false

    def commands(only: [], except: [])
      get_statistic(CommandStatistic, only: only, except: except)
    end

    def events(only: [], except: [])
      get_statistic(EventStatistic, only: only, except: except)
    end

    def special(only: [], except: [])
      get_statistic(SpecialStatistic, only: only, except: except)
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

  private

    def get_statistic(resource, only: [], except: [])
      if only.empty? && except.empty?
        resource.all
      elsif only.empty?
        resource.filtered(except: except)
      else
        resource.filtered(only: only)
      end
    end
  end
end
