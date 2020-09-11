class Admin::UsersController < ApplicationController
  before_action :sudo_is_admin

  def index
    @users = User.admins.where.not(id: current_user.id).order("created_at DESC")
    @user_invite = UserInvite.new
  end

  def new
    @user_invite = UserInvite.new
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(account_update_params)
        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
        format.json { respond_with_bip(@user) }
      else
        format.html { render :index }
        format.json { respond_with_bip(@user) }
      end
    end
  end

  private
  # If you have extra params to permit, append them to the sanitizer.
  def account_update_params
    params.require(:user).permit(:is_active)
    # devise_parameter_sanitizer.permit(:account_update, keys: [:is_active])
  end

end
