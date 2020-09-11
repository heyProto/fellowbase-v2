# coding: utf-8
# == Schema Information
#
# Table name: digital_assets
#
#  id                      :integer          not null, primary key
#  asset                   :string
#  headline                :string
#  publication             :string
#  publish_date            :date
#  post_type               :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  airtable_id             :string
#  tracked                 :boolean
#  last_requested_unixtime :integer
#  custom_errors           :text
#  item_id                 :integer
#  last_update_unixtime    :integer
#  creation_unixtime       :integer
#  channel_id              :integer
#  _type                   :string
#

class DigitalAsset < ApplicationRecord
  #CONSTANTS
  POST_TYPE_CONSTANTS = ["Journalism produced", "Tool", "Story about work", "Announcement", "Resource"]
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  has_many :event_digital_assets, dependent: :destroy
  has_many :events, through: :event_digital_assets
  has_many :trackable_metrics, dependent: :destroy

  belongs_to :channel, optional: true
  #ACCESSORS
  attr_accessor :skip_callbacks
  #VALIDATIONS

  # https://stackoverflow.com/a/39198430/5671433
  # Modified regex for ruby from above link
  a = /\A(https?:\/\/)(www\.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)|\A(https?:\/\/)(www\.)?(?!ww)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)/

  validates :asset, {presence: true}
  validates :asset, format: {with: a, message: "Must be a valid URL. Add http:// or https:// at the start of the URL if not added."}
  validates :post_type, inclusion: { in: DigitalAsset::POST_TYPE_CONSTANTS, message: "Should be in predefined post types"}, allow_nil: true, allow_blank: true
  #CALLBACKS
  after_destroy :delete_item_from_channel
  before_create :add_item_to_impact_monitor

  before_update :add_item_to_impact_monitor
  before_update :update_asset_url_in_impact_monitor

  after_update  :initiate_tracker_worker

  #SCOPE
  scope :with_no_data, -> { where.not(custom_errors: "") }
  scope :successful, -> { where(custom_errors: "") }
  scope :errored, -> { where(tracked: false) }

  #OTHER
  class << self
    def create_or_update(attrs)
      asset = DigitalAsset.where(digital_asset_id: attrs[:digital_asset_id]).first
      unless asset.blank?
        # Update
        asset = asset.update_attributes(
          asset: attrs[:asset],
          headline: attrs[:headline],
          genre: attrs[:genre],
          publication: attrs[:publication],
          event_id: attrs[:event_id],
          post_type: attrs[:post_type]
        )
      else
        # Create
        asset = DigitalAsset.create(attrs)
      end
      asset
    end
  end
  #PRIVATE
  private

  def delete_item_from_channel
    if self.tracked == true and self.item_id.present?
      response = ImpactMonitorApi.delete_item(self.item_id, self.channel.unique_id_token)
    end
    true
  end

  def add_item_to_impact_monitor
    current_channel = Channel.get_current_channel
    if self.tracked == false or self.tracked.nil?
      self.last_requested_unixtime = Time.now.to_i
      impact_monitor_item = ImpactMonitorApi.add_monitored_item(self.asset, current_channel.unique_id_token)
      # puts "---- #{impact_monitor_item}"
      if impact_monitor_item["success"]
        item_obj = impact_monitor_item["items"]
        i_o = item_obj.first
        if i_o["success"]
          monitored_item_id = i_o["monitored_item_id"]
          self.item_id = monitored_item_id
          self.tracked = true
          self.channel_id = current_channel.id
        else
          self.tracked = false
          self.custom_errors = "Impact Monitor: Could not add the link."
        end
      else
        self.tracked = false
        self.custom_errors = "Impact Monitor: Could not add the link."
      end
    end
    true
  end

  def update_asset_url_in_impact_monitor
    if self.asset_changed? and self.tracked == true
      response = ImpactMonitorApi.update_item(self.item_id, self.asset)
      if response["success"]
        return true
      else
        return false
      end
    end
    true
  end

  def initiate_tracker_worker
    if self.tracked == true
      self.update_column(:custom_errors, "")
      self.update_column(:last_requested_unixtime, Time.now.to_i)
      # Initiate the workers.
      TrackableMetricSocialShareWorker.perform_at(1.second.from_now, self.item_id)
      TrackableMetricTwitterWorker.perform_at(2.second.from_now, self.item_id)
      ItemOverviewWorker.perform_at(3.second.from_now, self.item_id)
    end
    true
  end
end
