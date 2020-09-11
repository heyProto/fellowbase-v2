# == Schema Information
#
# Table name: events
#
#  id                 :integer          not null, primary key
#  description        :string
#  is_confidential    :boolean
#  event_date         :date
#  is_review_required :boolean
#  notes              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  airtable_id        :string
#

class Event < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  has_many :event_ref_impacts, dependent: :destroy
  has_many :ref_impacts, through: :event_ref_impacts

  has_many :event_projects, dependent: :destroy
  has_many :projects, through: :event_projects

  has_many :event_users, dependent: :destroy
  has_many :users, through: :event_users

  has_many :event_digital_assets, dependent: :destroy
  has_many :digital_assets, through: :event_digital_assets

  accepts_nested_attributes_for :event_digital_assets, allow_destroy: true, reject_if: :all_blank

  has_many :event_ref_countries, dependent: :destroy
  has_many :ref_countries, through: :event_ref_countries

  has_many :event_ref_partners, dependent: :destroy
  has_many :ref_partners, through: :event_ref_partners

  has_many :reports
  #ACCESSORS


  attr_accessor :event_ref_impacts_list
  attr_accessor :event_projects_list
  attr_accessor :event_users_list
  attr_accessor :event_digital_assets_list
  attr_accessor :event_ref_countries_list
  attr_accessor :event_ref_partners_list
  #VALIDATIONS
  #CALLBACKS
  after_create :add_event_ref_impacts,
               :add_event_projects,
               :add_event_users,
               :add_event_digital_assets,
               :add_event_ref_countries,
               :add_event_ref_partners

  after_update :update_event_ref_impacts,
               :update_event_projects,
               :update_event_users,
               :update_event_digital_assets,
               :update_event_ref_countries,
               :update_event_ref_partners

  #SCOPE
  #OTHER
  def add_event_ref_impacts
    event_ref_impacts_list.split(',').each do |a|
      EventRefImpact.create(event_id: self.id, ref_impact_id: a.to_i)      
    end
  end

  def add_event_projects
    event_projects_list.split(',').each do |a|
      EventProject.create(event_id: self.id, project_id: a.to_i)      
    end
  end

  def add_event_users
    event_users_list.split(',').each do |a|
      EventUser.create(event_id: self.id, user_id: a.to_i)      
    end
  end

  def add_event_digital_assets
    event_digital_assets_list.split(',').each do |a|
      EventDigitalAsset.create(event_id: self.id, digital_asset_id: a.to_i)      
    end
  end

  def add_event_ref_countries
    event_ref_countries_list.split(',').each do |a|
      EventRefCountry.create(event_id: self.id, ref_country_id: a.to_i)
    end
  end

  def add_event_ref_partners
    event_ref_partners_list.split(',').each do |a|
      EventRefPartner.create(event_id: self.id, ref_partner_id: a.to_i)
    end
  end


  def update_event_ref_impacts
    unless event_ref_impacts_list.nil?
      EventRefImpact.where(event_id: self.id).delete_all
      event_ref_impacts_list.split(',').each do |a|
        EventRefImpact.create(event_id: self.id, ref_impact_id: a.to_i)
      end
    end
  end

  def update_event_projects
    unless event_projects_list.nil?
      EventProject.where(event_id: self.id).delete_all
      event_projects_list.split(',').each do |a|
        EventProject.create(event_id: self.id, project_id: a.to_i)
      end
    end
  end

  def update_event_users
    unless event_users_list.nil?
      EventUser.where(event_id: self.id).delete_all
      event_users_list.split(',').each do |a|
        EventUser.create(event_id: self.id, user_id: a.to_i)
      end
    end
  end

  def update_event_digital_assets
    unless event_digital_assets_list.nil?
      EventDigitalAsset.where(event_id: self.id).delete_all
      event_digital_assets_list.split(',').each do |a|
        if a.to_i.to_s == a
          EventDigitalAsset.create(event_id: self.id, digital_asset_id: a.to_i)
        else
          if DigitalAsset.where(asset: a).first.present?
            EventDigitalAsset.create(event_id: self.id, digital_asset_id: DigitalAsset.where(asset: a).first.id)
          end
        end
      end
    end
  end

  def update_event_ref_countries
    unless event_ref_countries_list.nil?
      EventRefCountry.where(event_id: self.id).delete_all
      event_ref_countries_list.split(',').each do |a|
        EventRefCountry.create(event_id: self.id, ref_country_id: a.to_i)
      end
    end
  end

  def update_event_ref_partners
    unless event_ref_partners_list.nil?
      EventRefPartner.where(event_id: self.id).delete_all
      event_ref_partners_list.split(',').each do |a|
        EventRefPartner.create(event_id: self.id, ref_partner_id: a.to_i)
      end
    end
  end

  def short_description
    if self.description.present?
      if self.description.length > 200
        self.description[0..200].to_s + "..."
      else
        self.description.to_s
      end
    else
      "-"
    end
  end
#PRIVATE
end
