class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    token = authenticate_user(params[:email], params[:password])

    if token
      render json: { auth_token: token }
    else
      render json: { error: 'Invalid credentials.' }, status: :unauthorized
    end
  end

  def authenticate_user(email, password)
    user = User.find_by_email(email)
    if user && user.authenticate(password)
      JsonWebToken.encode(user_id: user.id)
    else
      nil
    end
  end

end
