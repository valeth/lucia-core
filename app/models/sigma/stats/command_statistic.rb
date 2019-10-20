# frozen_string_literal: true

class CommandStatistic
  include Mongoid::Document
  include Filterable

  store_in collection: "CommandStats"

  field :command, as: :name, type: String
  field :count, type: Integer

  def to_list_entry
    { command.to_sym => count }
  end

  class << self
    def total_commands_executed
      CommandStatistic.all.pluck(:count).sum
    end
  end
end
