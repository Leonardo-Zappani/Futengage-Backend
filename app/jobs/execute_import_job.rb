class ExecuteImportJob < ApplicationJob
  queue_as :imports

  def perform(import_id)
    import = Import.find(import_id)

    case import.source
    when :zero_paper
      Imports::ZeroPaper.call(import:, account: import.account)
    else
      Rails.logger.warn('>>>>>>>>>>>>>>>>>>>>>')
      Rails.logger.warn('Source not identified')
      Rails.logger.warn('>>>>>>>>>>>>>>>>>>>>>')
    end
  end
end
