module Types
  class SigmaType < Types::BaseObject
    implements Interfaces::Sigma::CommandList

    field :info, Types::Sigma::BotInfoType, null: false do
      description "Various information about Sigma"
    end

    field :command_categories, [Types::Sigma::CommandCategoryType], null: false

    field :leaderboard, [Types::Sigma::LeaderboardEntryType], null: false do
      argument :type, String, required: true
      argument :guild_id, GraphQL::Types::BigInt, required: false
    end

    field :stats, Types::Sigma::StatsSetType, null: false

    def leaderboard(type:, guild_id: nil)
      resource = Leaderboard[type]
      guild_id ? resource.by_guild_id(guild_id) : resource.get
    end

    def command_categories
      CommandCategory.all
    end

    def stats
      {}
    end

    def info
      BotVersion.first
    end
  end
end
