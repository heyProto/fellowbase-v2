class Admin::RefTargetsController < ApplicationController
  before_action :sudo_is_admin
  before_action :set_ref_target, only: [:update, :destroy]

  def index
    @ref_targets = RefTarget.active.order("created_at DESC")
    @ref_target = RefTarget.new
  end

  def new
    @ref_target = RefTarget.new
  end

  def create
    @ref_target = RefTarget.new(ref_target_params)
    @ref_target.is_active = 1
    if @ref_target.save
      redirect_to admin_ref_targets_path, notice: "Target was created successfully"
    else
      redirect_to admin_ref_targets_path, notice: "Target already exists"
    end

  end

  def update
    respond_to do |format|
      if @ref_target.update(ref_target_params)
        format.html { redirect_to admin_ref_targets_path, notice: 'Target was successfully updated.' }
        format.json { respond_with_bip(@ref_target) }
      else
        format.html { render :index }
        format.json { respond_with_bip(@ref_target) }
      end
    end
  end

  def destroy
    @ref_target.is_active = 0
    if @ref_target.save
      redirect_to admin_ref_targets_path, notice: "Target was destroyed successfully"
    else
      redirect_to admin_ref_targets_path, alert: "Something went wrong"
    end
  end

  private

  def set_ref_target
    @ref_target = RefTarget.find(params[:id])
  end

  def ref_target_params
    params.require(:ref_target).permit(:name)
  end
end
