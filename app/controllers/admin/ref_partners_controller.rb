class Admin::RefPartnersController < ApplicationController
  before_action :sudo_is_admin
  before_action :set_ref_partner, only: [:update, :destroy]

  def index
    @ref_partners = RefPartner.active.order("created_at DESC")
    @ref_partner = RefPartner.new
    @ref_countries = RefCountry.active.order("name ASC")
  end

  def new
    @ref_partner = RefPartner.new
    @ref_countries = RefCountry.active.order("name ASC")
  end

  def create
    @ref_partner = RefPartner.new(ref_partner_params)
    @ref_partner.creator = current_user
    @ref_partner.updater = current_user
    @ref_partner.is_active = 1
    if @ref_partner.save
      redirect_to admin_ref_partners_path, notice: "Partner was created successfully"
    else
      redirect_to admin_ref_partners_path, notice: @ref_partner.errors.messages[:name]
    end

  end

  def update
    @ref_partner.updater = current_user
    @ref_partner.save
    respond_to do |format|
      if @ref_partner.update(ref_partner_params)
        format.html { redirect_to admin_ref_partners_path, notice: 'Partner was successfully updated.' }
        format.json { respond_with_bip(@ref_partner) }
      else
        format.html { render :index }
        format.json { respond_with_bip(@ref_partner) }
      end
    end
  end

  def destroy
    @ref_partner.is_active = 0
    @ref_partner.updater = current_user
    if @ref_partner.save
      redirect_to admin_ref_partners_path, notice: "Partner was destroyed successfully"
    else
      redirect_to admin_ref_partners_path, alert: "Something went wrong"
    end
  end

  private

  def set_ref_partner
    @ref_partner = RefPartner.find(params[:id])
  end

  def ref_partner_params
    params.require(:ref_partner).permit(:name, :ref_country_id)
  end

end
