class QueryAnalyzer
  QueryDepthAnalyzer = GraphQL::Analysis::QueryDepth
  QueryComplexityAnalyzer = GraphQL::Analysis::QueryComplexity

  def initialize(&block)
    @depth_analyzer = QueryDepthAnalyzer.new
    @complexity_analyzer = QueryComplexityAnalyzer.new
    @handler = block
  end

  def analyze?(query)
    Rails.env.development?
  end

  def initial_value(query)
    {
      query: query,
      depth: @depth_analyzer.initial_value(query),
      complexity: @complexity_analyzer.initial_value(query)
    }
  end

  def call(memo, visit_type, irep_node)
    memo[:depth] = call_depth_analyzer(memo[:depth], visit_type, irep_node)
    memo[:complexity] = call_complexity_analyzer(memo[:complexity], visit_type, irep_node)
    memo
  end

  def final_value(memo)
    depth = memo.dig(:depth, :max_depth)
    complexity = memo.dig(:complexity, :complexities_on_type, -1).max_possible_complexity
    @handler.call(memo[:query], depth, complexity)
  end

private

  def call_depth_analyzer(memo, visit_type, irep_node)
    @depth_analyzer.call(memo, visit_type, irep_node)
  end

  def call_complexity_analyzer(memo, visit_type, irep_node)
    @complexity_analyzer.call(memo, visit_type, irep_node)
  end
end
