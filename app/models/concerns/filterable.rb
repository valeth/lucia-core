# frozen_string_literal: true

module Filterable
  extend ActiveSupport::Concern

  class_methods do
    def filtered(**criteria)
      if criteria.key?(:only)
        self.in(name: criteria[:only])
      elsif criteria.key?(:except)
        not_in(name: criteria[:except])
      else
        all
      end
    end
  end
end
