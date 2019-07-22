module Types::Sigma
  class CommandCategoryType < Types::BaseObject
    field :name, String, null: false
    field :commands, [Types::Sigma::CommandType], null: false
  end
end
