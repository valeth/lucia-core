module Types
  class SigmaType < Types::BaseObject
    implements Interfaces::Sigma::CommandList

    field :info, Types::Sigma::BotInfoType, null: false do
      description "Various information about Sigma"
    end

    field :command_categories, [Types::Sigma::CommandCategoryType], null: false

    field :leaderboard, [Types::Sigma::LeaderboardEntryType], null: false do
      argument :type, Types::Sigma::LeaderboardKind, required: true, as: :resource
      argument :guild_id, GraphQL::Types::BigInt, required: false, default_value: nil
    end

    def leaderboard(resource:, guild_id:)
      guild_id ? resource.by_guild_id(guild_id) : resource.get
    end

    def command_categories
      CommandCategory.all
    end

    def info
      BotVersion.first
    end
  end
end
