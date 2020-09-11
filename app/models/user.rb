# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  role                   :string           default("fellow")
#  is_active              :boolean          default(TRUE)
#  airtable_id            :string
#  selected_dimensions    :string
#

# https://stackoverflow.com/questions/21249749/rails-4-devise-omniauth-with-multiple-providers

class User < ApplicationRecord

  #CONSTANTS
  ROLES = ['fellow', 'admin']
  SOCIALS = {twitter: 'Twitter'}

  #CUSTOM TABLES

  #GEMS
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  #ASSOCIATIONS
  has_many :authentications
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :event_users, dependent: :destroy
  has_many :events, through: :event_users
  #ACCESSORS
  after_create :delete_invite

  #VALIDATIONS
  validates :role, inclusion: {in: User::ROLES, message: "Should be either 'fellow' or 'admin'"}
  validates :name, presence: true
  validates :name, uniqueness: true
  #CALLBACKS
  #SCOPE
  scope :admins, -> {where(role: "admin")}
  scope :fellows, -> {where(role: "fellow")}
  scope :active, -> {where(is_active: true)}
  #OTHER

  def is_admin?
    self.role == "admin" ? true : false
  end

  def self.from_omniauth(auth)
    if user = User.where(email: auth.info.email).first
      return user
    else
      return {"errors": "User with email #{auth.info.email} does not exist."}
    end
  end

  def fetch_details(auth)
    self.name = auth.info.name
    self.email = auth.info.email
    self.profile_picture = auth.info.image
  end

  # https://stackoverflow.com/questions/6004216/devise-how-do-i-forbid-certain-users-from-signing-in
  def active_for_authentication?
    super and (self.role == "admin")
  end

  def inactive_message
    "You are not allowed to log in."
  end

  def gravatar_image
    "https://www.gravatar.com/avatar/#{self.email_hash_digest}"
  end

  def email_hash_digest
    Digest::MD5.hexdigest(self.email)
  end

  def is_active?
    self.is_active
  end

  def delete_invite
    if UserInvite.where(email: self.email).first.present?
      UserInvite.where(email: self.email).first.delete
    end
  end

  protected
  # https://stackoverflow.com/a/15838947/5671433
  def email_required?
    self.role == "fellow" ? false : true
  end

  def password_required?
    false
  end

  # Dont send email on email change by admin
  def postpone_email_change?
   false
  end
  #PRIVATE
end
