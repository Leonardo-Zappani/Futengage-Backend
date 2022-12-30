# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_21_213933) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "account_invitations", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "invited_by_id", null: false
    t.integer "role_cd", default: 0, null: false
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["account_id"], name: "index_account_invitations_on_account_id"
    t.index ["invited_by_id"], name: "index_account_invitations_on_invited_by_id"
  end

  create_table "account_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.integer "role_cd", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["role_cd"], name: "index_account_users_on_role_cd"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "default_currency", limit: 3, default: "BRL"
    t.string "country_code", limit: 2, default: "BR"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.bigint "owner_id"
    t.bigint "company_id", null: false
    t.string "processor_customer_id"
    t.string "processor_plan_id"
    t.string "processor_plan_name"
    t.string "subscription_status", default: "incomplete"
    t.date "trial_ends_at"
    t.bigint "balance_cents", default: 0, null: false
    t.string "balance_currency", limit: 3, default: "BRL", null: false
    t.boolean "admin", default: false, null: false
    t.integer "account_type_cd", default: 0, null: false
    t.index ["company_id"], name: "index_accounts_on_company_id"
    t.index ["discarded_at"], name: "index_accounts_on_discarded_at"
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "auditable_id"
    t.string "auditable_type"
    t.bigint "associated_id"
    t.string "associated_type"
    t.bigint "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["account_id"], name: "index_audits_on_account_id"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "account_type_cd", default: 0, null: false
    t.string "name", null: false
    t.boolean "default", default: false, null: false
    t.bigint "initial_balance_cents", default: 0, null: false
    t.string "initial_balance_currency", limit: 3, default: "BRL", null: false
    t.bigint "balance_cents", default: 0, null: false
    t.string "balance_currency", limit: 3, default: "BRL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_bank_accounts_on_account_id"
    t.index ["account_type_cd"], name: "index_bank_accounts_on_account_type_cd"
  end

  create_table "domains", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "type", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["account_id", "type", "discarded_at"], name: "index_domains_on_account_id_and_type_and_discarded_at"
    t.index ["account_id"], name: "index_domains_on_account_id"
    t.index ["discarded_at"], name: "index_domains_on_discarded_at"
    t.index ["type"], name: "index_domains_on_type"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string "from", limit: 3, null: false
    t.string "to", limit: 3, null: false
    t.decimal "rate", precision: 20, scale: 5, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from", "to"], name: "index_exchange_rates_on_from_and_to"
  end

  create_table "imports", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "source_cd"
    t.integer "state_cd"
    t.bigint "progress_number"
    t.bigint "progress_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_imports_on_account_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "people", force: :cascade do |t|
    t.bigint "account_id"
    t.string "type", null: false
    t.integer "person_type_cd", default: 0, null: false
    t.string "first_name", null: false
    t.string "last_name"
    t.string "document_1"
    t.string "document_2"
    t.string "email"
    t.string "phone_number"
    t.date "birth_date"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.integer "contact_type_cd", default: 0, null: false
    t.index ["account_id", "type", "discarded_at"], name: "index_people_on_account_id_and_type_and_discarded_at"
    t.index ["account_id"], name: "index_people_on_account_id"
    t.index ["contact_type_cd"], name: "index_people_on_contact_type_cd"
    t.index ["discarded_at"], name: "index_people_on_discarded_at"
    t.index ["person_type_cd"], name: "index_people_on_person_type_cd"
    t.index ["type"], name: "index_people_on_type"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "bank_account_id", null: false
    t.bigint "contact_id"
    t.bigint "category_id"
    t.bigint "cost_center_id"
    t.bigint "transfer_to_id"
    t.bigint "installment_source_id"
    t.integer "transaction_type_cd", default: 0, null: false
    t.integer "payment_method_cd", default: 0, null: false
    t.integer "payment_type_cd", default: 0, null: false
    t.integer "installment_type_cd"
    t.boolean "paid", default: false, null: false
    t.datetime "paid_at"
    t.date "due_date", null: false
    t.date "competency_date"
    t.string "document_number"
    t.string "name"
    t.text "description"
    t.integer "installment_number"
    t.integer "installment_total"
    t.bigint "amount_cents", default: 0, null: false
    t.string "amount_currency", limit: 3, default: "BRL", null: false
    t.bigint "exchanged_amount_cents", default: 0, null: false
    t.string "exchanged_amount_currency", limit: 3, default: "BRL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "import_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["bank_account_id"], name: "index_transactions_on_bank_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["contact_id"], name: "index_transactions_on_contact_id"
    t.index ["cost_center_id"], name: "index_transactions_on_cost_center_id"
    t.index ["due_date"], name: "index_transactions_on_due_date"
    t.index ["import_id"], name: "index_transactions_on_import_id"
    t.index ["installment_source_id"], name: "index_transactions_on_installment_source_id"
    t.index ["installment_type_cd"], name: "index_transactions_on_installment_type_cd"
    t.index ["paid"], name: "index_transactions_on_paid"
    t.index ["payment_method_cd"], name: "index_transactions_on_payment_method_cd"
    t.index ["payment_type_cd"], name: "index_transactions_on_payment_type_cd"
    t.index ["transaction_type_cd"], name: "index_transactions_on_transaction_type_cd"
    t.index ["transfer_to_id"], name: "index_transactions_on_transfer_to_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "preferred_language"
    t.string "time_zone"
    t.boolean "admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "accepted_terms_at"
    t.datetime "accepted_privacy_at"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "account_invitations", "accounts"
  add_foreign_key "account_invitations", "users", column: "invited_by_id"
  add_foreign_key "account_users", "accounts"
  add_foreign_key "account_users", "users"
  add_foreign_key "accounts", "people", column: "company_id"
  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audits", "accounts"
  add_foreign_key "bank_accounts", "accounts"
  add_foreign_key "domains", "accounts"
  add_foreign_key "imports", "accounts"
  add_foreign_key "people", "accounts"
  add_foreign_key "taggings", "tags"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "bank_accounts"
  add_foreign_key "transactions", "bank_accounts", column: "transfer_to_id"
  add_foreign_key "transactions", "domains", column: "category_id"
  add_foreign_key "transactions", "domains", column: "cost_center_id"
  add_foreign_key "transactions", "imports"
  add_foreign_key "transactions", "people", column: "contact_id"
  add_foreign_key "transactions", "transactions", column: "installment_source_id"
  add_foreign_key "users", "accounts"
end
