class UserInvitationMailer < ApplicationMailer
  def invite_user(user_invite)
    @user_invite = user_invite
    @url  = 'http://139.59.25.62'
    @sign_up_url = 'http://139.59.25.62/users/sign_up'
    mail(to: @user_invite.email, subject: "Invitation for #{@url.to_s}")
  end
end
