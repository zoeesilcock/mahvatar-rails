class UsersController < ApplicationController
  before_action :find_user, :authenticate_user

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = 'Your mahvatar has been successfully updated!'
    end

    render :edit
  end

  private
  def user_params
    params.require(:user).permit(:name, :head)
  end

  def find_user
    @user = User.find params[:id]
  end

  def authenticate_user
    if !@user.auth_token_at || @user.auth_token != params[:auth_token]
      render nothing: true, status: :unauthorized
    end
  end
end
