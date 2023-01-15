# == Schema Information
#
# Table name: places
#
#  id         :bigint           not null, primary key
#  address    :string           not null
#  day        :string           not null
#  name       :string           not null
#  time       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_places_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class Place < ApplicationRecord
  belongs_to :team

  has_many :matches, dependent: :destroy
  has_many :confirmed_matches, -> { where.not(confirmed_at: nil) }, class_name: 'Match'
  has_many :unconfirmed_matches, -> { where(confirmed_at: nil) }, class_name: 'Match'
end
