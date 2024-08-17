class GraphqlController < ApplicationController
  rescue_from StandardError, with: :error_logger

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    result = LuciaCoreSchema.execute(query, variables:, operation_name:)
    render json: result
  end

private

  def error_logger(err)
    logger.error err.message

    if Rails.env.development?
      logger.error err.backtrace.join("\n")
      render json: { error: { message: err.message, backtrace: err.backtrace }, data: {} }, status: 500
    else
      render json: { error: { message: "GraphQL query execution failed" }, data: {} }, status: 500
    end
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
