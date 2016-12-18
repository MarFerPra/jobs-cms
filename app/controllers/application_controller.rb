class ApplicationController < ActionController::API
  include ActionController::Serialization

  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = authorize_request(request.headers)
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def authorize_request headers
    return nil unless headers['Authorization'].present?

    http_auth_header = headers['Authorization'].split(' ').last
    decoded_auth_token = JsonWebToken.decode(http_auth_header)

    if decoded_auth_token
      User.find(decoded_auth_token[:user_id])
    else
      nil
    end

  end

end
