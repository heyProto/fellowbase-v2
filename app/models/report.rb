# == Schema Information
#
# Table name: event_report
#
#  event_id          :integer
#  event_name        :string
#  fellow            :string
#  impact_type       :string
#  impact_type_genre :string
#  ref_partner_id    :integer
#  partner_name      :string
#  project_id        :integer
#  project_name      :string
#  digital_asset_id  :integer
#  asset             :string
#  post_type         :string
#  metric_id         :integer
#  metric_type       :string
#  genre             :string
#  value             :integer
#

class Report < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  self.table_name = "event_report"
  #GEMS
  #ASSOCIATIONS
  belongs_to :event
  #ACCESSORS
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  class << self
    def refresh
      Report.connection.execute("REFRESH MATERIALIZED VIEW event_report;")
    end
  end
#PRIVATE
end
