# == Schema Information
#
# Table name: ref_partners
#
#  id             :integer          not null, primary key
#  name           :string
#  ref_country_id :integer
#  created_by     :string
#  updated_by     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_active      :boolean
#  airtable_id    :string
#

class RefPartner < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :ref_country, optional: true
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by'
  belongs_to :updater, class_name: 'User', foreign_key: 'updated_by'

  has_many :project_ref_partners, dependent: :destroy
  has_many :projects, through: :project_ref_partners

  has_many :event_ref_partners, dependent: :destroy
  has_many :events, through: :event_ref_partners
  #ACCESSORS
  #VALIDATIONS
  validates :name, uniqueness: { scope: [:ref_country_id], message: "Partner already exists" }
  validates :name, presence: true
  #CALLBACKS
  #SCOPE
  scope :active, -> {where(is_active: true)}
  #OTHER
  #PRIVATE

end
