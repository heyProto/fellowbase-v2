class Admin::RefImpactsController < ApplicationController
  before_action :sudo_is_admin
  before_action :set_ref_impact, only: [:update, :destroy]

  def index
    @ref_impacts = RefImpact.active.order("created_at DESC")
    @ref_impact = RefImpact.new
  end

  def new
    @ref_impact = RefImpact.new
  end

  def create
    @ref_impact = RefImpact.new(ref_impact_params)
    @ref_impact.creator = current_user
    @ref_impact.updater = current_user
    @ref_impact.is_active = 1
    if @ref_impact.save
      redirect_to admin_ref_impacts_path, notice: "Impact was created successfully"
    else
      redirect_to admin_ref_impacts_path, notice: @ref_impact.errors.messages[:name]
    end

  end

  def update
    @ref_impact.updater = current_user
    @ref_impact.save
    respond_to do |format|
      if @ref_impact.update(ref_impact_params)
        format.html { redirect_to admin_ref_impacts_path, notice: 'Impact was successfully updated.' }
        format.json { respond_with_bip(@ref_impact) }
      else
        format.html { render :index }
        format.json { respond_with_bip(@ref_impact) }
      end
    end
  end

  def destroy
    @ref_impact.is_active = 0
    @ref_impact.updater = current_user
    if @ref_impact.save
      redirect_to admin_ref_impacts_path, notice: "Impact was destroyed successfully"
    else
      redirect_to admin_ref_impacts_path, alert: "Something went wrong"
    end
  end

  private

  def set_ref_impact
    @ref_impact = RefImpact.find(params[:id])
  end

  def ref_impact_params
    params.require(:ref_impact).permit(:name, :genre)
  end
end
