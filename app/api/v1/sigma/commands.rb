# frozen_string_literal: true

class API::V1::Sigma::Commands < Grape::API
  namespace :commands do
    params do
      optional :filter, type: Hash, allow_blank: false
      given :filter do
        optional :filter, type: Hash do
          optional :name, type: String, allow_blank: false
          optional :desc, type: String, allow_blank: false
          at_least_one_of :name, :desc
        end
      end
    end

    get do
      categories =
        if params[:filter]
          CommandCategory.all
            .sort(name: 1)
            .map { |c| c.filter_commands(params[:filter]) }
            .select(&:commands_available?)
        else
          CommandCategory.all
            .sort(name: 1)
            .select(&:commands_available?)
        end

      present categories, with: ::Entities::BotCommandCategory
    end
  end
end
