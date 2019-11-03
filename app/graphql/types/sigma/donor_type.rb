module Types::Sigma
  class DonorType < Types::BaseObject
    field :tier, Integer, null: false
    field :user, Types::DiscordUser, null: true
  end
end
