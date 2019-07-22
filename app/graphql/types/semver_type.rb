module Types
  class SemverType < Types::BaseObject
    description "Version number in semver format"

    field :major, Int, null: false
    field :minor, Int, null: false
    field :patch, Int, null: false
  end
end
