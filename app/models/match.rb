# == Schema Information
#
# Table name: matches
#
#  id             :bigint           not null, primary key
#  confirmed_at   :datetime
#  scheduled_at   :datetime
#  team_one_name  :string           default("team one"), not null
#  team_one_score :string           default("0"), not null
#  team_two_name  :string           default("team two"), not null
#  team_two_score :string           default("0"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :bigint           not null
#  place_id       :bigint           not null
#  team_id        :bigint           not null
#
# Indexes
#
#  index_matches_on_owner_id  (owner_id)
#  index_matches_on_place_id  (place_id)
#  index_matches_on_team_id   (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (place_id => places.id)
#  fk_rails_...  (team_id => teams.id)
#
class Match < ApplicationRecord
  belongs_to :team
  belongs_to :place
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  has_many :confirmations, dependent: :destroy
  # has_many :confirmed_members, through: :confirmations, -> { where(confirmations: { confirmed: true }) }, source: :member
  # has_many :unconfirmed_members, through: :confirmations, -> { where(confirmations: { confirmed: false }) }, source: :member


  after_create :add_confirmations_to_members

  private

  def add_confirmations_to_members
    team.members.each do |member|
      confirmations.create(member: member)
    end
  end
end
