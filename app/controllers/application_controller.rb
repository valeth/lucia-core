class ApplicationController < ActionController::API
  include ActionController::Caching

  before_action :authenticate

private

  def authenticate
    token = request.headers["X-Lucia-Token"]

    if token.nil? || token.empty?
      render status: 401
    else
      validator = LuciaToken::FormatValidator.new(prefix: "lc-")
      render status: 403 unless validator.valid?(token)
    end
  end
end
