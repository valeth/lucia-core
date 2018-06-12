# frozen_string_literal: true

module Sigma
  class CommandsController < ApplicationController
    CommandsError = Class.new(StandardError)

    rescue_from CommandsError do |e|
      render json: { error: e.message }, status: 500
    end

    def index
      @categories = CommandCategory.all.sort(name: 1).select(&:commands_available?)
      search_filter = commands_parameters[:filter]
      return unless search_filter.present?
      @categories
        .map! { |c| c.filter_commands(search_filter) }
        .select!(&:commands_available?)
    end

  private

    def commands_parameters
      params.permit(filter: [:name, :desc])
    end
  end
end
