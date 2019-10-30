class LuciaCoreSchema < GraphQL::Schema
  def self.logger
    Logging.logger["GraphQL"]
  end

  analyzer = QueryAnalyzer.new do |_query, depth, complexity|
    logger.debug { "query_depth=#{depth} query_complexity=#{complexity}" }
  end

  query_analyzer(analyzer)

  disable_introspection_entry_points if Rails.env.production?

  query Types::QueryType
end
