module Types::Sigma
  class LeaderboardEntryType < Types::BaseObject
    field :user, Types::DiscordUser, null: false
    field :score, Integer, null: false

    field :origins, Types::Sigma::LeaderboardOriginType, null: false
    field :expenses, Types::Sigma::LeaderboardExpensesType, null: true
  end
end
