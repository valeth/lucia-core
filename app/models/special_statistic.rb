# frozen_string_literal: true

class SpecialStatistic
  include Mongoid::Document

  store_in client: "sigma", collection: "SpecialStats"

  field :name, type: String
  field :count, type: Integer
end
