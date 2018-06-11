# frozen_string_literal: true

class EventStatistic
  include Mongoid::Document

  store_in client: "sigma", collection: "EventStats"

  field :event, as: :name, type: String
  field :count, type: Integer
end
