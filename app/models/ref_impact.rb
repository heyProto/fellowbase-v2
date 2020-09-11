# == Schema Information
#
# Table name: ref_impacts
#
#  id          :integer          not null, primary key
#  name        :string
#  genre       :string
#  created_by  :string
#  updated_by  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_active   :boolean
#  airtable_id :string
#

class RefImpact < ApplicationRecord
  #CONSTANTS
  GENRES_CONSTANTS = ["Media Outcome", "Societal Outcome", "Activity", "Output"]

  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  belongs_to :updater, class_name: 'User', foreign_key: 'updated_by'

  has_many :event_ref_impacts, dependent: :destroy
  has_many :events, through: :event_ref_impacts
  #ACCESSORS
  #VALIDATIONS
  validates :name, presence: true
  validates :name, uniqueness: { scope: [:genre], message: "Impact already exists" }
  validates :genre, inclusion: { in: RefImpact::GENRES_CONSTANTS, message: "Should be from predefined Genres"}, allow_nil: true, allow_blank: true
  #CALLBACKS
  #SCOPE
  scope :active, -> {where(is_active: true)}
  #OTHER
  #PRIVATE

end
