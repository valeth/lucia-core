class LuciaCoreSchema < GraphQL::Schema
  def self.logger
    Logging.logger["GraphQL"]
  end

  disable_introspection_entry_points if Rails.env.production?

  query Types::QueryType
end
