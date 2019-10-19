# frozen_string_literal: true

class Resource
  def self.[](name)
    @resources ||= {}
    @resources[name.to_sym] ||= Class.new do
      include Score

      store_in collection: "#{name.downcase.camelize}Resource"
    end
  end
end
