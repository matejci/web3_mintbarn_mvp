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

ActiveRecord::Schema[7.0].define(version: 2022_04_05_165341) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "apps", force: :cascade do |t|
    t.string "app_id"
    t.string "app_type"
    t.string "name"
    t.string "description"
    t.boolean "status", default: true
    t.string "supported_versions", array: true
    t.string "public_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_apps_on_app_id"
  end

  create_table "chains", force: :cascade do |t|
    t.string "name"
    t.string "rpc_url"
    t.string "block_explorer_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "etherscan_api_url"
    t.index ["name"], name: "index_chains_on_name", unique: true
  end

  create_table "chains_wallet_accounts", id: false, force: :cascade do |t|
    t.bigint "chain_id"
    t.bigint "wallet_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.string "name"
    t.string "contract_symbol"
    t.string "contract_type"
    t.bigint "chain_id"
    t.string "owner_address"
    t.boolean "metadata_updateable", default: false
    t.string "transaction_hash"
    t.string "transaction_external_url"
    t.string "contract_address"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chain_id"], name: "index_contracts_on_chain_id"
  end

  create_table "eth_historical_prices", force: :cascade do |t|
    t.string "utc_date"
    t.string "unix_timestamp"
    t.string "usd_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["utc_date"], name: "index_eth_historical_prices_on_utc_date", unique: true
  end

  create_table "nfts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "wallet_account_id"
    t.bigint "chain_id"
    t.integer "status", default: 0
    t.string "contract_address"
    t.string "transaction_hash"
    t.string "transaction_external_url"
    t.string "mint_error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "metadata_uri"
    t.string "external_url"
    t.string "signature"
    t.string "token_id"
    t.string "mint_type"
    t.index ["chain_id"], name: "index_nfts_on_chain_id"
    t.index ["wallet_account_id"], name: "index_nfts_on_wallet_account_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "last_login"
    t.datetime "last_activity"
    t.datetime "token_valid_until"
    t.string "token_salt"
    t.string "token"
    t.string "user_agent"
    t.string "ip_address"
    t.boolean "live"
    t.boolean "status", default: true
    t.string "player_id"
    t.string "device_name"
    t.string "device_type"
    t.string "device_client_name"
    t.string "device_client_full_version"
    t.string "device_os"
    t.string "device_os_full_version"
    t.boolean "device_known"
    t.bigint "user_id"
    t.bigint "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_sessions_on_app_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "description"
    t.decimal "balance"
    t.decimal "usd_balance"
    t.bigint "chain_id"
    t.bigint "wallet_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chain_id"], name: "index_tokens_on_chain_id"
    t.index ["name", "chain_id", "wallet_account_id"], name: "index_tokens_on_name_and_chain_id_and_wallet_account_id", unique: true
    t.index ["wallet_account_id"], name: "index_tokens_on_wallet_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "website"
    t.date "dob"
    t.string "username"
    t.string "display_name"
    t.boolean "tos_accepted", default: false
    t.datetime "tos_accepted_at"
    t.string "tos_accepted_ip"
    t.boolean "admin", default: false
    t.string "password_digest"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  create_table "wallet_accounts", force: :cascade do |t|
    t.string "wallet_name"
    t.string "account_name"
    t.string "address"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_name", "wallet_name"], name: "index_wallet_accounts_on_account_name_and_wallet_name", unique: true
    t.index ["address"], name: "index_wallet_accounts_on_address", unique: true
    t.index ["user_id"], name: "index_wallet_accounts_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "contracts", "chains"
  add_foreign_key "nfts", "chains"
  add_foreign_key "nfts", "wallet_accounts"
  add_foreign_key "sessions", "users"
  add_foreign_key "tokens", "chains"
  add_foreign_key "tokens", "wallet_accounts"
end
