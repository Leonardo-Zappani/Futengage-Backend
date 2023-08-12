# == Schema Information
#
# Table name: confirmations
#
#  id           :bigint           not null, primary key
#  active       :boolean          default(TRUE)
#  confirmed    :boolean          default(FALSE), not null
#  confirmed_at :datetime
#  position     :integer
#  team_number  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  match_id     :bigint           not null
#  member_id    :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_confirmations_on_match_id   (match_id)
#  index_confirmations_on_member_id  (member_id)
#  index_confirmations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (member_id => members.id)
#  fk_rails_...  (user_id => users.id)
#
class Confirmation < ApplicationRecord
  belongs_to :member
  belongs_to :match

  enum position: { goleiro: 0, zagueiro: 1, lateral: 2, meia: 3, ponta: 4, centroavante: 5 }

  after_create_commit -> {broadcast_prepend_to 'confirmations', target: 'confirmations', partial: 'application/visualization', locals: { confirmation: self }}
  after_update_commit -> {broadcast_replace_to 'confirmations', target: 'confirmations', partial: 'application/visualization', locals: { confirmation: self }}


  has_one :team, through: :member
  has_one :user, through: :member
  has_one :place, through: :match
end
