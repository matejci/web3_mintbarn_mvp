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

ActiveRecord::Schema[7.0].define(version: 2022_05_03_172515) do
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
    t.string "explorer_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_chains_on_name", unique: true
  end

  create_table "chains_wallet_accounts", id: false, force: :cascade do |t|
    t.bigint "chain_id"
    t.bigint "wallet_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nfts", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.string "description"
    t.json "metadata"
    t.boolean "is_mutable"
    t.boolean "is_master_edition", default: false
    t.integer "seller_fee_basis_points", default: 0
    t.string "creators", array: true
    t.string "share", array: true
    t.string "mint_to_public_key"
    t.bigint "wallet_account_id"
    t.bigint "chain_id"
    t.string "metadata_url"
    t.string "explorer_url"
    t.string "mint_address"
    t.string "mint_secret_recovery_phrase"
    t.boolean "primary_sale_happened", default: false
    t.string "transaction_signature"
    t.string "update_authority"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "price_in_lamports"
    t.string "list_tx_signature"
    t.string "transfer_tx_signature"
    t.index ["chain_id"], name: "index_nfts_on_chain_id"
    t.index ["creators"], name: "index_nfts_on_creators", using: :gin
    t.index ["share"], name: "index_nfts_on_share", using: :gin
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

  create_table "solana_tokens", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.string "mint_address"
    t.integer "decimals"
    t.string "icon_url"
    t.string "website"
    t.integer "market_cap_rank"
    t.decimal "price_usd"
    t.json "market_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  add_foreign_key "nfts", "chains"
  add_foreign_key "nfts", "wallet_accounts"
  add_foreign_key "sessions", "users"
  add_foreign_key "tokens", "chains"
  add_foreign_key "tokens", "wallet_accounts"
end
