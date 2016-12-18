class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    @user = User.new(user_params)

    if @user.save
      render json: 'User successfully created.', status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
