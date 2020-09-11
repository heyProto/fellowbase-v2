class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def sudo_is_admin
    redirect_to root_url, notice: "Permission denied." if (!user_signed_in? or !current_user.is_admin?)
  end
end
