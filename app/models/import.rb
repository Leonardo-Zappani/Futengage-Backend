# == Schema Information
#
# Table name: imports
#
#  id              :bigint           not null, primary key
#  progress_number :bigint
#  progress_total  :bigint
#  source_cd       :integer
#  state_cd        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#
# Indexes
#
#  index_imports_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Import < ApplicationRecord
  include Imports::Constants
  include Auditable

  has_many :transactions, dependent: :delete_all
  belongs_to :account

  as_enum :state, IMPORTS_STATES
  as_enum :source, IMPORTS_SOURCES

  has_one_attached :file

  after_create_commit :start_import_job
  after_update_commit -> { broadcast_replace_to 'imports' }

  def current_progress
    return 0.0 if progress_number.zero? || progress_total.zero?

    (progress_number.to_f / progress_total * 100)
  end

  private

  def start_import_job
    ExecuteImportJob.perform_later(id)
  end
end
