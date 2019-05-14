# frozen_string_literal: true

class SpecialStatistic
  include Mongoid::Document

  store_in collection: "SpecialStats"

  field :name, type: String
  field :count, type: Integer

  def to_list_entry
    { name.to_sym => count }
  end
end
