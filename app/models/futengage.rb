# == Schema Information
#
# Table name: futengages
#
#  id           :bigint           not null, primary key
#  confirmed_at :datetime
#  day          :datetime         not null
#  name         :string           default("Futengage"), not null
#  place        :string           default("Clubinho"), not null
#  team_name_1  :string           default("Time 1"), not null
#  team_name_2  :string           default("Time 2"), not null
#  team_score_1 :bigint           default(0), not null
#  team_score_2 :bigint           default(0), not null
#  time         :string           default("20h"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint
#
# Indexes
#
#  index_futengages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Futengage < ApplicationRecord
  has_many :users
  def callbacks
    @current_futengage = Futengage.where(futengage.day > Time.now).first
  end

end
