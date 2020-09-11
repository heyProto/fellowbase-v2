# == Schema Information
#
# Table name: event_ref_countries
#
#  id             :integer          not null, primary key
#  event_id       :integer
#  ref_country_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class EventRefCountry < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :event
  belongs_to :ref_country
  #ACCESSORS
  attr_accessor :event_ref_countries_list
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
