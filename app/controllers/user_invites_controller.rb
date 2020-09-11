class UserInvitesController < ApplicationController
  before_action :sudo_is_admin
  before_action :set_user_invite, only: [:destroy]
  before_action :check_if_already_exists, only: [:create]

  def create
    @user_invite = UserInvite.new(user_invite_params)
    @user_invite.sender = current_user
    respond_to do |format|
      if @user_invite.save
        UserInvitationMailer.invite_user(@user_invite).deliver_later
        format.html { redirect_to admin_users_path, notice: 'Invite was successfully sent.' }
        format.json { render :show, status: :created, location: @user_invite }
      else
        format.html { render :new }
        format.json { render json: @user_invite.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_invite.destroy
  end

  private
  def set_user_invite
    @user_invite = UserInvite.find(params[:id])
  end

  def user_invite_params
    params.require(:user_invite).permit(:email)
  end

  def check_if_already_exists
    if user_invite_params[:email] == ""
      redirect_to admin_users_path, notice: "Please enter a valid email"
    elsif User.where(email: user_invite_params[:email]).first.present?
      redirect_to admin_users_path, notice: "User already exists"
    elsif UserInvite.where(email: user_invite_params[:email]).first.present?
      redirect_to admin_users_path, notice: "Invitation has already been sent"
    end
  end
end
