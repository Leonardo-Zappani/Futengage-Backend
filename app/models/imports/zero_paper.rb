module Imports
  class ZeroPaper < ApplicationInteractor
    include ActionView::Helpers::NumberHelper

    COLUMN_NAMES = {
      TRANSACTION_TYPE: 0,
      DUE_DATE: 1,
      COMPETENCY_DATE: 2,
      NAME: 3,
      AMOUNT: 4,
      CATEGORY: 5,
      CONTACT: 6,
      PAID: 7,
      DESCRIPTION: 8,
      BANK_ACCOUNT: 9,
      DOCUMENT_NUMBER: 10,
      PAYMENT_METHOD: 11,
      COST_CENTER: 12,
      TAGS: 13
    }.freeze

    TRANSACTION_TYPES = {
      REVENUE: 'Recebimentos',
      FIXED_EXPENSE: 'Despesas fixas',
      VARIABLE_EXPENSE: 'Despesas variáveis',
      PAYROLL: 'Pessoas',
      TAX: 'Impostos',
      TRANSFER_IN: 'Transferências Entrada',
      TRANSFER_OUT: 'Transferências Saída'
    }.freeze

    PAYMENT_METHODS = {
      '' => :no_payment_method,
      nil => :no_payment_method,
      'Cartão de crédito' => :credit_card,
      'Cheque' => :check,
      'Boleto bancário' => :bank_slip,
      'Dinheiro' => :cash
    }.freeze

    def call
      import = context.import

      # Import transfers
      import.file.open do |file|
        transactions = []
        batch_size = 100

        # Abre o arquivo da planilha
        workbook = SimpleXlsxReader.open(file)
        worksheet = workbook.sheets.first

        # Reseta os dados de progresso do import
        reset_import_progress(import:, worksheet:)

        # Para cara items da planilha
        worksheet.rows.each_with_index do |row, index|
          next if index.zero?

          # Incrementa o contador de items processados
          increment_import_progress(import:)

          case strip_value(row[COLUMN_NAMES[:TRANSACTION_TYPE]])
          when strip_value(TRANSACTION_TYPES[:REVENUE])           # Se for um recebimento
            transactions << build_transaction(row:, transaction_type: :revenue)
          when strip_value(TRANSACTION_TYPES[:FIXED_EXPENSE])     # Se for uma despesa fixa
            transactions << build_transaction(row:, transaction_type: :fixed_expense)
          when strip_value(TRANSACTION_TYPES[:VARIABLE_EXPENSE])  # Se for uma despesa variável
            transactions << build_transaction(row:, transaction_type: :variable_expense)
          when strip_value(TRANSACTION_TYPES[:PAYROLL])           # Se for uma transação de folha de pagamento / pessoas
            transactions << build_transaction(row:, transaction_type: :payroll)
          when strip_value(TRANSACTION_TYPES[:TAX])               # Se for um imposto
            transactions << build_transaction(row:, transaction_type: :tax)
          when strip_value(TRANSACTION_TYPES[:TRANSFER_OUT]) # Se for uma transferência de saída
            transaction = build_transfer_transaction(file:, row:)
            transactions << transaction if transaction.valid?
          else
            next
          end

          # Se o index não é multiplo de 100
          next unless (index % batch_size).zero?

          ActiveRecord::Base.transaction do
            Transaction.import!(transactions, validate: false)
            import.save!
          end

          transactions = []
        end

        Transaction.import!(transactions, validate: false) if transactions.any?
      end

      # Atualiza o saldo das contas bancárias
      context.account.bank_accounts.each(&:update_balance!)

      # Atualiza o saldo da conta
      context.account.update_balance!

      # If the progress_number is equal to zero, the application did not read, therefore, it failed, otherwise it is terminated
      context.fail!(error: I18n.t('imports.create.fail_import')) if import.progress_number.zero?

      # Finaliza os dados da importação
      finish_import_progress(import:)
    end

    private

    def reset_import_progress(import:, worksheet:)
      import.progress_total = worksheet.rows.count - 1
      import.progress_number = 0
      import.state = :in_progress
      import.save!
    end

    def increment_import_progress(import:)
      import.progress_number = (import.progress_number + 1)
    end

    def finish_import_progress(import:)
      import.state = :done if context.success?
      import.save!
    end

    def extract_category(row:)
      category_name = strip_value(row[COLUMN_NAMES[:CATEGORY]])
      return nil if category_name.blank?

      context.account.categories.find_or_create_by(name: category_name)
    end

    def extract_cost_center(row:)
      cost_center_name = strip_value(row[COLUMN_NAMES[:COST_CENTER]])
      return nil if cost_center_name.blank?

      context.account.cost_centers.find_or_create_by(name: cost_center_name)
    end

    def extract_contact(row:)
      contact_name = strip_value(row[COLUMN_NAMES[:CONTACT]])
      return nil if contact_name.blank?

      context.account.contacts.find_or_create_by(first_name: contact_name)
    end

    def extract_paid(row:)
      strip_value(row[COLUMN_NAMES[:PAID]]) == 'Sim'
    end

    def extract_name(row:)
      name = strip_value(row[COLUMN_NAMES[:NAME]])
      return nil if name.blank?

      name
    end

    def extract_description(row:)
      description = strip_value(row[COLUMN_NAMES[:DESCRIPTION]])
      return nil if description.blank?

      description
    end

    def extract_bank_account(row:)
      bank_account_name = strip_value(row[COLUMN_NAMES[:BANK_ACCOUNT]])
      return nil if bank_account_name.blank?

      context.account.bank_accounts.create_with(default: false).find_or_create_by(name: bank_account_name)
    end

    def extract_transfer_to(file:, row:)
      bank_account = nil

      workbook = SimpleXlsxReader.open(file)
      worksheet = workbook.sheets.first

      worksheet.rows.each_with_index do |row_in, index_in|
        next if bank_account.present?
        next if index_in.zero?
        next unless same_transfer?(row_out: row, row_in:)

        bank_account = extract_bank_account(row: row_in)
      end

      if bank_account.nil?
        Rails.logger.info('>>>>>>>>>>>>>>>>>>>>>>')
        Rails.logger.info('Bank account not found')
        Rails.logger.info('>>>>>>>>>>>>>>>>>>>>>>')
        Rails.logger.debug row
        Rails.logger.info('>>>>>>>>>>>>>>>>>>>>>>')
      end

      bank_account
    end

    def extract_due_date(row:)
      row[COLUMN_NAMES[:DUE_DATE]] { Date.current }
    end

    def extract_amount(row:)
      amount = row[COLUMN_NAMES[:AMOUNT]]
      return 0 if amount.to_s.strip.blank?

      amount
    end

    def extract_tags(row:)
      tags = strip_value(row[COLUMN_NAMES[:TAGS]])
      return nil if tags.blank?

      tags
    end

    def extract_document_number(row:)
      document_number = strip_value(row[COLUMN_NAMES[:DOCUMENT_NUMBER]])
      return nil if document_number.blank?

      document_number
    end

    def extract_payment_method(row:)
      payment_method = strip_value(row[COLUMN_NAMES[:PAYMENT_METHOD]])
      return :no_payment_method if payment_method.blank?

      PAYMENT_METHODS[payment_method] || :no_payment_method
    end

    def same_transfer?(row_out:, row_in:)
      (strip_value(row_in[COLUMN_NAMES[:TRANSACTION_TYPE]]) == strip_value(TRANSACTION_TYPES[:TRANSFER_IN])) &&
        (strip_value(row_out[COLUMN_NAMES[:DUE_DATE]]) == strip_value(row_in[COLUMN_NAMES[:DUE_DATE]])) &&
        (strip_value(row_out[COLUMN_NAMES[:NAME]]) == strip_value(row_in[COLUMN_NAMES[:NAME]])) &&
        (strip_value(row_out[COLUMN_NAMES[:AMOUNT]]) == strip_value(row_in[COLUMN_NAMES[:AMOUNT]])) &&
        (strip_value(row_out[COLUMN_NAMES[:PAID]]) == strip_value(row_in[COLUMN_NAMES[:PAID]]))
    end

    def strip_value(value)
      val = value.to_s.strip
      return nil if val.blank?

      val
    end

    def build_transfer_transaction(file:, row:)
      context.account.transactions.new(
        bank_account: extract_bank_account(row:),
        transfer_to: extract_transfer_to(file:, row:),
        transaction_type: :transfer,
        due_date: extract_due_date(row:),
        name: extract_name(row:),
        amount_cents: number_with_precision(extract_amount(row:), precision: 2),
        amount_currency: context.account.default_currency,
        category: extract_category(row:),
        paid: extract_paid(row:),
        import: context.import
      )
    end

    def build_transaction(row:, transaction_type:)
      context.account.transactions.new(
        bank_account: extract_bank_account(row:),
        category: extract_category(row:),
        contact: extract_contact(row:),
        cost_center: extract_cost_center(row:),
        transaction_type:,
        due_date: extract_due_date(row:),
        name: extract_name(row:),
        amount_cents: number_with_precision(extract_amount(row:), precision: 2),
        amount_currency: context.account.default_currency,
        paid: extract_paid(row:),
        description: extract_description(row:),
        document_number: extract_document_number(row:),
        payment_method: extract_payment_method(row:),
        tag_list: extract_tags(row:),
        import: context.import
      )
    end
  end
end
