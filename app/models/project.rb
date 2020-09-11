# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  airtable_id :string
#

class Project < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users

  has_many :project_ref_partners, dependent: :destroy
  has_many :ref_partners, through: :project_ref_partners

  has_many :event_projects, dependent: :destroy
  has_many :events, through: :event_projects

  #ACCESSORS
  attr_accessor :name_list
  attr_accessor :partner_list
  #VALIDATIONS
  validates :name, presence: true
  #CALLBACKS
  after_create :add_users
  after_create :add_partners
  after_update :update_users
  after_update :update_partners
  #SCOPE
  #OTHER
  def add_users
    # Gets a csv string from the controller
    name_list.split(',').each do |user|
      ProjectUser.create(project_id: self.id, user_id: user.to_i)
    end
  end

  def add_partners
    partner_list.split(',').each do |partner|
      ProjectRefPartner.create(project_id: self.id, ref_partner_id: partner.to_i)
    end
  end

  def update_users
    ProjectUser.where(project_id: self.id).delete_all
    name_list.split(',').each do |user|
      ProjectUser.create(project_id: self.id, user_id: user.to_i)
    end
  end

  def update_partners
    ProjectRefPartner.where(project_id: self.id).delete_all
    partner_list.split(',').each do |partner|
      ProjectRefPartner.create(project_id: self.id, ref_partner_id: partner.to_i)
    end
  end
#PRIVATE
end
