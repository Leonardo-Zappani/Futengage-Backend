# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :invitable

  has_person_name
  has_one_attached :avatar

  belongs_to :futengage, optional: true

  has_many :members, dependent: :destroy
  has_many :teams, through: :members
  has_many :owned_teams, class_name: 'Team', foreign_key: 'owner_id', dependent: :destroy
  has_many :owned_matches, class_name: 'Match', foreign_key: 'owner_id', dependent: :destroy
  has_many :places, through: :teams
  has_many :matches, through: :teams
  has_many :pending_confirmations, -> { where(confirmations: { confirmed: false }) }, through: :members, source: :confirmations
  has_many :confirmed_confirmations, -> { where(confirmations: { confirmed: true }) }, through: :members, source: :confirmations

  def full_name
    "#{first_name} #{last_name}"
  end

  def avatar_url
    if avatar.attached?
      avatar.variant(resize_to_fill: [100, 100]).processed
    else
      "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=100&d=identicon"
    end
  end
end
