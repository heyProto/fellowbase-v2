class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:update, :destroy, :show, :edit]

  def new
    @event = Event.new
    @event.event_digital_assets.build.build_digital_asset
    @ref_impacts = RefImpact.active
    @projects = Project.all
    @fellows = User.fellows.active
    # # For Digital Asset modal
    # @digital_asset = DigitalAsset.new
    @digital_assets = DigitalAsset.all
    @ref_countries = RefCountry.active
    @ref_partners = RefPartner.active
  end

  def edit
    @ref_impacts = RefImpact.active
    @projects = Project.all
    @fellows = User.fellows.active
    # # For Digital Asset modal
    @digital_asset = DigitalAsset.new
    @digital_assets = DigitalAsset.all
    @ref_countries = RefCountry.active
    @ref_partners = RefPartner.active
  end

  def index
    @events = Event.all.order("created_at DESC")
  end

  def show
  end

  def create
    @event = Event.new(event_params)
    build_event_digital_assets

    if @event.save
      redirect_to events_path, notice: "Event was created successfully"
    else
      redirect_to events_path, alert: "Something went wrong"
    end
  end

  def update
    # update_event_digital_assets
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
        format.json { respond_with_bip(@event) }
      else
        format.html { redirect_to events_path, alert: "Something went wrong" }
        format.json { respond_with_bip(@event) }
      end
    end
  end

  def destroy
    if @event.destroy
      redirect_to events_path, notice: "Event was destroyed successfully"
    else
      redirect_to events_path, alert: "Something went wrong"
    end
  end

  def build_event_digital_assets
    @event.event_digital_assets.each do |eda|
      eda.digital_asset = DigitalAsset.create(
        asset: eda.digital_asset.asset,
        headline: eda.digital_asset.headline,
        publication: eda.digital_asset.publication,
        publish_date: eda.digital_asset.publish_date,
        post_type: eda.digital_asset.post_type,
      )
    end
  end

  # def update_event_digital_assets
  #   @event.event_digital_assets.each do |eda|
  #     asd
  #     a = DigitalAsset.find_or_initialize_by(id: eda.digital_asset.id)
  #     a.asset = eda.digital_asset.asset
  #     a.headline = eda.digital_asset.headline
  #     a.publication = eda.digital_asset.publication
  #     a.publish_date = eda.digital_asset.publish_date
  #     a.post_type = eda.digital_asset.post_type
  #     # a.save
  #   end
  # end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:description,
                                  :is_confidential,
                                  :event_date,
                                  :is_review_required,
                                  :notes,
                                  :event_ref_impacts_list,
                                  :event_projects_list,
                                  :event_users_list,
                                  :event_digital_assets_list,
                                  :event_ref_partners_list,
                                  :event_ref_countries_list,
                                  event_digital_assets_attributes:
                                    [:id,
                                     digital_asset_attributes: [
                                       :id,
                                       :asset,
                                       :headline,
                                       :publication,
                                       :publish_date,
                                       :post_type,
                                     ]
                                    ]
                                 )
  end
end
