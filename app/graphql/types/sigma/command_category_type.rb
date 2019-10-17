module Types::Sigma
  class CommandCategoryType < Types::BaseObject
    implements Interfaces::Sigma::CommandList

    field :name, String, null: false
  end
end
