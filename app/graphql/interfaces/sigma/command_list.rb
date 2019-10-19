module Interfaces::Sigma
  module CommandList
    include Interfaces::Base

    description "Filtered list of available bot commands"

    field :commands, type: [Types::Sigma::CommandType], null: false do
      argument :nsfw, Types::Sigma::CommandFilter, required: false
      argument :admin, Types::Sigma::CommandFilter, required: false
      argument :partner, Types::Sigma::CommandFilter, required: false
      argument :regex, GraphQL::Types::String, required: false
    end

    def commands(regex: nil, nsfw: :exclude, admin: :include, partner: :include)
      params = {}
      params[:nsfw] = false if nsfw == :exclude
      params[:admin] = false if admin == :exclude
      params[:partner] = false if partner == :exclude

      if regex
        object.commands.find_by_name_or_desc(regex, **params)
      else
        object.commands.where(**params)
      end
    end
  end
end
