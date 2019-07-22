module Types::Sigma
  class CommandType < Types::BaseObject
    field :name, String, null: false
    field :alternative_names, [String], null: false, method: :alts

    field :description, String, null: false, method: :desc
    field :usage, String, null: false
    field :category, Types::Sigma::CommandCategoryType, null: false

    field :admin, Boolean, null: false
    field :partner, Boolean, null: false
    field :nsfw, Boolean, null: false
  end
end
