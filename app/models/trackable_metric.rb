# == Schema Information
#
# Table name: trackable_metrics
#
#  id               :integer          not null, primary key
#  item_id          :integer
#  digital_asset_id :integer
#  genre            :string
#  metric_type      :string
#  value            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class TrackableMetric < ApplicationRecord
  #GEMS
  #ATTRIBUTES
  #ASSOCIATIONS
  belongs_to :digital_asset
  #VALIDATIONS
  #CALLBACKS
  #FUNCTIONS

  class << self
    def create_or_update(item_id, asset_id, genre, metric_type, value)
      metric = TrackableMetric.where({
                                       item_id: item_id,
                                       digital_asset_id: asset_id,
                                       genre: genre,
                                       metric_type: metric_type,
                                     }).first

      metric = TrackableMetric.create({
                                        item_id: item_id,
                                        digital_asset_id: asset_id,
                                        genre: genre,
                                        metric_type: metric_type,
                                      }) if metric.blank?

      metric.update_column(:value, value)
    end
  end

  #PRIVATE
end
