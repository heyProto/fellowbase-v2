# == Schema Information
#
# Table name: ref_targets
#
#  id          :integer          not null, primary key
#  name        :string
#  is_active   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  airtable_id :string
#

class RefTarget < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  #ACCESSORS
  #VALIDATIONS
  validates :name, presence: true
  validates :name, uniqueness: true
  #CALLBACKS
  scope :active, -> {where(is_active: true)}
  #SCOPE
  #OTHER
  #PRIVATE
end
