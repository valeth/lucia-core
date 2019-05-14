# frozen_string_literal: true

class CommandStatistic
  include Mongoid::Document

  store_in collection: "CommandStats"

  field :command, as: :name, type: String
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

  def to_list_entry
    { command.to_sym => count }
  end
end
