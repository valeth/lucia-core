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

      if !token_used?(token) && validator.valid?(token)
        mark_token_as_used(token)
      else
        render status: 403
      end
    end
  end

  def token_used?(token)
    Rails.cache.exist?(token)
  end

  def mark_token_as_used(token)
    return if Rails.configuration.lucia["token_reusable"]

    expire_time = [Rails.configuration.lucia["token_expiration_time"], 1].max
    Rails.cache.write(token, nil, expires_in: expire_time.seconds)
  end
end
