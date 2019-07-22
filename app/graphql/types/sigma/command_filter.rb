module Types::Sigma
  class CommandFilter < Types::BaseEnum
    value "INCLUDE", value: :include
    value "EXCLUDE", value: :exclude
  end
end
