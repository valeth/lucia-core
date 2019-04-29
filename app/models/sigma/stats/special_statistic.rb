# frozen_string_literal: true

class SpecialStatistic
  include Mongoid::Document

  store_in collection: "SpecialStats"

  field :name, type: String
  field :count, type: Integer
end