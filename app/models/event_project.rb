# == Schema Information
#
# Table name: event_projects
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventProject < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :event
  belongs_to :project
  #ACCESSORS
  attr_accessor :event_projects_list
  #VALIDATIONS
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
