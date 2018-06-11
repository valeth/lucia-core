# frozen_string_literal: true

class CommandStatistic
  include Mongoid::Document

  store_in client: "sigma", collection: "CommandStats"

  field :command, as: :name, type: String
  field :count, type: Integer
end
