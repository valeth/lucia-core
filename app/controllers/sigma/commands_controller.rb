module Sigma
  class CommandsController < ApplicationController
    CommandsError = Class.new(StandardError)

    rescue_from CommandsError do |e|
      render json: { error: e.message }, status: 500
    end

    def index
      @categories = categorized_commands

      search_filter = commands_parameters[:filter]
      return unless search_filter.present?
      @categories
        .map! { |c| c.filter_commands(search_filter) }
        .select!(&:commands_available?)
    end

  private

    def module_list
      Rails.configuration.x.sigma_path.join("sigma/modules").glob("**/module.yml")
    end

    def categorized_commands
      module_list
        .map { |f| YAML.load_file(f) }
        .reject { |x| x["category"].nil? }
        .sort_by { |x| x["category"] }
        .group_by { |x| x["category"] }
        .map { |catname, cat| CommandCategory.new(catname, cat) }
        .select(&:commands_available?)
    rescue SystemCallError, YAML::Exception
      raise CommandsError, "Failed to read module configuration"
    end

    def commands_parameters
      params.permit(filter: [:name, :desc])
    end
  end
end
