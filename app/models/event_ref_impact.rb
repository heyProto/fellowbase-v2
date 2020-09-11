# == Schema Information
#
# Table name: event_ref_impacts
#
#  id            :integer          not null, primary key
#  event_id      :integer
#  ref_impact_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class EventRefImpact < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :event
  belongs_to :ref_impact
  #ACCESSORS
  attr_accessor :event_ref_impacts_list
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
