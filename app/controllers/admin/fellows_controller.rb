class Admin::FellowsController < ApplicationController
  before_action :set_fellow, only: [:destroy, :update]

  def index
    @fellows = User.fellows.active.order("created_at DESC")
  end

  def new
    @fellow = User.new
  end

  def create
    @fellow = User.new(fellow_params)
    @fellow.role = "fellow"
    @fellow.password = "iamafellow"
    @fellow.is_active = false
    @fellow.skip_confirmation!
    if @fellow.save
      redirect_to admin_fellows_path, notice: "Fellow was created Successfully with password 'iamafellow'"
    else
      redirect_to admin_fellows_path, notice: "Something went wrong"
    end
  end

  def update
    respond_to do |format|
      if @fellow.update(fellow_params)
        format.html { redirect_to admin_fellows_path, notice: 'Target was successfully updated.' }
        format.json { respond_with_bip(@fellow) }
      else
        format.html { render :index }
        format.json { respond_with_bip(@fellow) }
      end
    end
  end

  def destroy
    @fellow.is_active = 0
    if @fellow.save
      redirect_to admin_fellows_path, notice: "Fellow was destroyed Successfully"
    else
      redirect_to admin_fellows_path, alert: "Something went wrong"
    end
  end

  private

  def fellow_params
    params.require(:user).permit(:name, :email)
  end

  def set_fellow
    @fellow = User.fellows.find(params[:id])
  end
end
