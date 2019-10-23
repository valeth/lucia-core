class ApplicationController < ActionController::API
  include ActionController::Caching

  before_action :authenticate

private

  def authenticate
    auth_type, token = request.headers["Authorization"]&.split

    if auth_type != "Token"
      render json: { error: "Authentication required" }, status: 401
    else
      LuciaToken::Authenticator.authenticate(token)
    end
  rescue LuciaToken::TokenIsEmpty => err
    render json: { error: err.message }, status: 401
  rescue LuciaToken::ValidationError => err
    render json: { error: err.message }, status: 403
  end
end
