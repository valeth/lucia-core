# frozen_string_literal: true

class EventStatistic
  include Mongoid::Document

  store_in collection: "EventStats"

  field :event, as: :name, type: String
  field :count, type: Integer

  def self.filtered(**criteria)
    if criteria.key?(:only)
      self.in(name: criteria[:only])
    elsif criteria.key?(:except)
      not_in(name: criteria[:except])
    else
      all
    end
  end
end
