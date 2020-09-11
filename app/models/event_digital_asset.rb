# == Schema Information
#
# Table name: event_digital_assets
#
#  id               :integer          not null, primary key
#  event_id         :integer
#  digital_asset_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class EventDigitalAsset < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :event
  belongs_to :digital_asset
  #ACCESSORS
  attr_accessor :event_digital_assets_list
  accepts_nested_attributes_for :digital_asset, reject_if: :all_blank
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
