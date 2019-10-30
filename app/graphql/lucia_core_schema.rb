class LuciaCoreSchema < GraphQL::Schema
  def self.logger
    Logging.logger["GraphQL"]
  end

  if Rails.env.development?
    query_depth_logger = GraphQL::Analysis::QueryDepth.new do |_query, depth|
      logger.debug { "query_depth=#{depth}" }
    end

    query_complexity_logger = GraphQL::Analysis::QueryComplexity.new do |_query, complexity|
      logger.debug { "query_complexity=#{complexity}" }
    end

    query_analyzer(query_complexity_logger)
    query_analyzer(query_depth_logger)
  end

  disable_introspection_entry_points if Rails.env.production?

  query Types::QueryType
end
