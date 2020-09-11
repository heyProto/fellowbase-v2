# == Schema Information
#
# Table name: user_invites
#
#  id         :integer          not null, primary key
#  email      :string
#  sender     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserInvite < ApplicationRecord
  #CONSTANTS
  #CUSTOM TABLES
  #GEMS
  #ASSOCIATIONS
  belongs_to :sender, class_name: 'User', foreign_key: 'sender'
  #ACCESSORS
  #VALIDATIONS
  validates :email, presence: true
  #CALLBACKS
  #SCOPE
  #OTHER
  #PRIVATE
end
