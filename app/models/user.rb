# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invited_by_type        :string
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("goleiro")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :invitable

  has_person_name
  has_one_attached :avatar

  enum role: { goleiro: 0, zagueiro: 1, lateral: 2, meia: 3, ponta: 4, centroavante: 5 }

  belongs_to :futengage

  has_many :members, dependent: :destroy
  has_many :teams, through: :members
  has_many :owned_teams, class_name: 'Team', foreign_key: 'owner_id', dependent: :destroy
  has_many :owned_matches, class_name: 'Match', foreign_key: 'owner_id', dependent: :destroy
  has_many :places, through: :teams
  has_many :matches, through: :teams
  has_many :unconfirmed_matches, -> { where(confirmations: { confirmed: false, confirmed_at: nil }) }, through: :matches, source: :confirmations
  has_many :next_matches, -> { where(matches: { active: true }) }, through: :teams, source: :matches
  has_many :pending_confirmations, -> { where(confirmations: { confirmed: false, confirmed_at: nil, active: true }) }, through: :members, source: :confirmations
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

  def next_match
    unconfirmed_matches&.order(scheduled_at: :asc)&.first
  end

  def next_confirmation
    return if pending_confirmations&.empty?

    next_match = pending_confirmations&.first&.match

    pending_confirmations&.each do |confirmation|
      next_match = confirmation.match if confirmation.match.scheduled_at > next_match.scheduled_at
    end

    next_match.confirmations.find_by(user_id: id)
  end
end
