class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.class.to_s == "Hash"
      flash[:alert] = user[:errors]
      redirect_to root_url and return
    end

    if user.persisted?
      sign_in user
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: User::SOCIALS[params[:action].to_sym])
      redirect_to root_url
    else
      session['devise.user_attributes'] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  User::SOCIALS.each do |k, _|
    alias_method k, :all
  end

  def failure
    flash[:errors] = "Something went wrong"
    redirect_to root_url
  end
end
