# == Schema Information
#
# Table name: project_ref_partners
#
#  id             :integer          not null, primary key
#  project_id     :integer
#  ref_partner_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ProjectRefPartner < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :project
  belongs_to :ref_partner
  #ACCESSORS
  attr_accessor :partner_list
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
