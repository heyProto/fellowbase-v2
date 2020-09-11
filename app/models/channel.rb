# == Schema Information
#
# Table name: channels
#
#  id                   :integer          not null, primary key
#  channel_id           :string
#  name                 :string
#  unique_id_token      :string
#  description          :string
#  creation_unixtime    :integer
#  last_update_unixtime :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  is_active            :boolean
#

class Channel < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  has_many :digital_assets
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  scope :active, -> { where(is_active: true) }
  #OTHER
  class << self
    def get_current_channel
      no_of_channels = ImpactMonitorApi.get_all_channels['channels'].count
      active_channel = Channel.active.first

      item_count = ImpactMonitorApi.get_channel_overview(active_channel.unique_id_token)["overview"]["item_count"]
      if item_count.to_i >= 250
        active_channel.is_active = false
        active_channel.save
        # Hash that comes from impact monitor gives name and uniqueid
        new_channel = ImpactMonitorApi.add_channel("Channel-#{no_of_channels + 1}")
        # New channel hash only returns channel unique id
        channel_id = ImpactMonitorApi.get_channel_overview(new_channel["uniqueid"])["channel_id"]
        a = Channel.create(name: new_channel['name'],
                           unique_id_token: new_channel['uniqueid'],
                           is_active: true,
                           channel_id: channel_id)
        return a
      else
        return active_channel
      end
    end
  end
  #PRIVATE
end
