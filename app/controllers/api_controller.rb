class ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  def authenticate
    authenticate_user_with_token || handle_bad_authentication
  end

  private

  def authenticate_user_with_token
    authenticate_with_http_token do |token, options|
      token = ApiKey.find_by(api_key: token)
      @current_user ||= token.user if token
    end
  end

  def handle_bad_authentication
    render json: { message: "Bad credentials" }, status: :unauthorized
  end

  def handle_not_found
    render json: { message: "Record not found" }, status: :not_found
  end

end
