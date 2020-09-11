# == Schema Information
#
# Table name: ref_countries
#
#  id          :integer          not null, primary key
#  name        :string
#  created_by  :integer
#  updated_by  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_active   :boolean
#  airtable_id :string
#

class RefCountry < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  belongs_to :updater, class_name: 'User', foreign_key: 'updated_by'

  has_many :event_ref_countries, dependent: :destroy
  has_many :events, through: :event_ref_countries
  #ACCESSORS
  #VALIDATIONS
  validates :name, presence: true

  #CALLBACKS
  #SCOPE
  scope :active, -> {where(is_active: true)}
  #OTHER
  #PRIVATE

end
