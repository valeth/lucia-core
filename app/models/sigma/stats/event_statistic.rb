# frozen_string_literal: true

class EventStatistic
  include Mongoid::Document
  include Filterable

  store_in collection: "EventStats"

  field :event, as: :name, type: String
  field :count, type: Integer

  def to_list_entry
    { event.to_sym => count }
  end
end
