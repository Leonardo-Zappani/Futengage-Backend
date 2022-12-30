# frozen_string_literal: true

# == Schema Information
#
# Table name: domains
#
#  id           :bigint           not null, primary key
#  description  :text
#  discarded_at :datetime
#  name         :string           not null
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :bigint           not null
#
# Indexes
#
#  index_domains_on_account_id                            (account_id)
#  index_domains_on_account_id_and_type_and_discarded_at  (account_id,type,discarded_at)
#  index_domains_on_discarded_at                          (discarded_at)
#  index_domains_on_type                                  (type)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Category < Domain
end
