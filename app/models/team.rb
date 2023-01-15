# == Schema Information
#
# Table name: teams
#
#  id            :bigint           not null, primary key
#  group_name    :string           not null
#  team_one_name :string           default("Time 1"), not null
#  team_two_name :string           default("Time 2"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint           not null
#
# Indexes
#
#  index_teams_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Team < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :matches, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :confirmed_matches, through: :places, source: :confirmed_matches
  has_many :unconfirmed_matches, through: :places, source: :unconfirmed_matches

  after_create :add_owner_as_member

  private

  def add_owner_as_member
    members.create(user: owner)
  end
end
