class DigitalAssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_projects, only: [:index]
  before_action :set_digital_asset, only: [:edit, :show, :update, :destroy]

  def index
    @digital_assets = DigitalAsset.all.order("created_at DESC")
    @digital_asset = DigitalAsset.new
  end

  def new
    @digital_asset = DigitalAsset.new
  end

  def edit
  end

  def create
    @digital_asset = DigitalAsset.new(digital_asset_params)
    respond_to do |format|
      if @digital_asset.save
        format.js
        format.html { redirect_to digital_assets_path, notice: 'Digital Asset was successfully created.' }
        format.json { render json: @digital_asset.as_json, status: :created, location: @digital_asset }
      else
        format.js { render json: @digital_asset, status: :unprocessable_entity }
        format.html { render :new }
        format.json { render json: @digital_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @digital_asset.save
    respond_to do |format|
      if @digital_asset.update(digital_asset_params)
        format.html { redirect_to digital_assets_path, notice: 'Digital asset was successfully updated.' }
        format.json { respond_with_bip(@digital_asset) }
      else
        format.html { render :index }
        format.json { respond_with_bip(@digital_asset) }
      end
    end
  end

  def destroy
    @digital_asset.destroy
    redirect_to digital_assets_path, notice: "Digital asset was destroyed successfully"
  end

  private

  def set_projects
    if user_signed_in?
      if current_user.is_admin?
        @projects = Project.all
      else
        @projects = current_user.projects
      end
    end
  end

  def set_digital_asset
    @digital_asset = DigitalAsset.find(params[:id])
  end

  def digital_asset_params
    params.require(:digital_asset).permit(:asset, :headline, :publication, :publish_date, :post_type)
  end
end

