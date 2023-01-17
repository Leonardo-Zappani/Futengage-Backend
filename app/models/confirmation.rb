# == Schema Information
#
# Table name: confirmations
#
#  id           :bigint           not null, primary key
#  confirmed    :boolean          default(FALSE), not null
#  confirmed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  match_id     :bigint           not null
#  member_id    :bigint           not null
#
# Indexes
#
#  index_confirmations_on_match_id   (match_id)
#  index_confirmations_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (member_id => members.id)
#
class Confirmation < ApplicationRecord
  belongs_to :member
  belongs_to :match

  has_one :team, through: :member
  has_one :user, through: :member
  has_one :place, through: :match
end
