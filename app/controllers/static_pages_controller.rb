class StaticPagesController < ApplicationController
  def home
    if current_user
  		redirect_to report_path
  	else
  		redirect_to new_user_session_path
  	end
  end
  def set_selected_dimensions
    user_id = params[:id]
    selected_dimensions = params[:selected_dimensions]
    user = User.find(user_id)
    if user.present?
      user.update_column(:selected_dimensions, selected_dimensions)
      render json: { success: true }, status: 200
    else
      render json: { success: false, error: "User not found." }, status: 404
    end
  end

end
