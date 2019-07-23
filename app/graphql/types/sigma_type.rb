module Types
  class SigmaType < Types::BaseObject
    field :info, Types::Sigma::BotInfoType, null: false do
      description "Various information about Sigma"
    end

    field :commands, [Types::Sigma::CommandType], null: false do
      description "List of bot commands"
      argument :nsfw, Types::Sigma::CommandFilter, required: false, default_value: :include
      argument :admin, Types::Sigma::CommandFilter, required: false, default_value: :include
      argument :partner, Types::Sigma::CommandFilter, required: false, default_value: :include
    end

    field :modules, [Types::Sigma::CommandCategoryType], null: false

    field :leaderboard, [Types::Sigma::LeaderboardEntryType], null: false do
      argument :type, Types::Sigma::LeaderboardKind, required: true, as: :resource
      argument :guild_id, GraphQL::Types::BigInt, required: false, default_value: nil
    end

    def leaderboard(resource:, guild_id:)
      guild_id ? resource.by_guild_id(guild_id) : resource.get
    end

    def modules
      CommandCategory.all
    end

    def info
      BotVersion.first
    end

    def commands(nsfw:, admin:, partner:)
      cmds = Command.all
      cmds = (nsfw == :include) ? cmds : cmds.reject(&:nsfw)
      cmds = (admin == :include) ? cmds : cmds.reject(&:admin)
      partner ? cmds : cmds.reject(&:partner)
    end
  end
end
