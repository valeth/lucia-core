module Types::Sigma
  class LeaderboardEntryType < Types::BaseObject
    field :user, Types::DiscordUser, null: false

    field :score, Float, null: false
    field :title, String, null: false
    field :tier, Integer, null: false

    field :current_level, Integer, null: false
    field :points_to_next_level, Integer, null: false, method: :next_level_required
    field :percent_to_next_level, Float, null: false, method: :next_level_percent

    field :origins, Types::Sigma::LeaderboardOriginType, null: false
    # field :expenses, Types::Sigma::LeaderboardExpensesType, null: true
  end
end
