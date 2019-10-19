# frozen_string_literal: true

module Types::Sigma
  class LeaderboardExpensesType < Types::BaseObject
    # FIXME: There is no Map type in GraphQL (yet?), so we are forced to use raw JSON here.
    field :users, GraphQL::Types::JSON, null: false
    field :guilds, GraphQL::Types::JSON, null: false
    field :channels, GraphQL::Types::JSON, null: false
    field :functions, GraphQL::Types::JSON, null: true
  end
end
