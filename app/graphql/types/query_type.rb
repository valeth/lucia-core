module Types
  class QueryType < Types::BaseObject
    field :sigma, Types::SigmaType, null: true

    def sigma
      {}
    end
  end
end
