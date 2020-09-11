class EventDigitalAssetsController < ApplicationController
  def new
    @event_digital_asset = EventDigitalAsset.new
    @event_digital_asset.build_digital_asset
  end
end
