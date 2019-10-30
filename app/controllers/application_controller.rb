class ApplicationController < ActionController::API
  include ActionController::Caching
  include ActionController::MimeResponds

  before_action :authenticate, except: :route_not_found

  def route_not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.json { render json: { error: "Resource not found" }, status: :not_found }
    end
  end

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
