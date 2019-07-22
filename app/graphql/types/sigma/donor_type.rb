module Types::Sigma
  class DonorType < Types::BaseObject
    field :user_id, GraphQL::Types::BigInt, null: false, hash_key: :duid
    field :tier, Integer, null: false
    field :name, String, null: false
    field :avatar, String, null: true
  end
end
