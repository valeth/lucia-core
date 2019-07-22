module Types::Sigma
  class BotInfoType < Types::BaseObject
    field :beta, Boolean, null: false
    field :build_date, Int, null: false
    field :codename, String, null: false
    field :version, Types::SemverType, null: true
  end
end
