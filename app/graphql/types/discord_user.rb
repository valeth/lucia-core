module Types
  class DiscordUser < Types::BaseObject
    field :name, String, null: false
    field :discriminator, Integer, null: false
    field :id, GraphQL::Types::BigInt, null: false
    field :avatar_url, String, null: true
  end
end
