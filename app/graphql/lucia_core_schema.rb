class LuciaCoreSchema < GraphQL::Schema
  if Rails.env.development?
    query_depth_logger = GraphQL::Analysis::QueryDepth.new do |_query, depth|
      Rails.logger.debug { "GraphQL | Query Depth = #{depth}" }
    end

    query_complexity_logger = GraphQL::Analysis::QueryComplexity.new do |_query, complexity|
      Rails.logger.debug { "GraphQL | Query Complexity = #{complexity}" }
    end

    query_analyzer(query_complexity_logger)
    query_analyzer(query_depth_logger)
  end

  query Types::QueryType
end
