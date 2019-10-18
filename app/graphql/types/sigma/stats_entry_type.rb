module Types::Sigma
  class StatsEntryType < Types::BaseObject
    field :name, String, null: false
    field :count, Integer, null: false
  end
end
