# == Schema Information
#
# Table name: event_ref_partners
#
#  id             :integer          not null, primary key
#  event_id       :integer
#  ref_partner_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class EventRefPartner < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :event
  belongs_to :ref_partner
  #ACCESSORS
  attr_accessor :event_ref_partners_list
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
