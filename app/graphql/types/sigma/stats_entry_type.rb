module Types::Sigma
  class StatsEntryType < Types::BaseObject
    field :name, String, null: false
    field :count, GraphQL::Types::BigInt, null: false
  end
end
