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

ActiveRecord::Schema[7.0].define(version: 2023_02_23_020434) do
  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "sms_conversation_id", null: false
    t.string "sid"
    t.text "body"
    t.string "status"
    t.string "direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["direction"], name: "index_messages_on_direction"
    t.index ["sms_conversation_id"], name: "index_messages_on_sms_conversation_id"
  end

  create_table "phone_callers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_number"], name: "index_phone_callers_on_phone_number"
  end

  create_table "phone_calls", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "phone_caller_id"
    t.string "sid"
    t.string "number"
    t.string "from_number"
    t.string "from_city"
    t.string "from_province"
    t.string "from_country"
    t.string "tree_name"
    t.string "direction"
    t.string "answered_by"
    t.boolean "unanswered", default: false
    t.string "call_status"
    t.integer "length_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_phone_calls_on_created_at"
    t.index ["direction"], name: "index_phone_calls_on_direction"
    t.index ["phone_caller_id"], name: "index_phone_calls_on_phone_caller_id"
    t.index ["sid"], name: "index_calls_on_sid"
    t.index ["tree_name"], name: "index_phone_calls_on_tree_name"
  end

  create_table "recordings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "phone_call_id", null: false
    t.string "recording_sid"
    t.string "duration"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone_call_id"], name: "index_recordings_on_call_id"
  end

  create_table "responses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "phone_call_id"
    t.bigint "recording_id"
    t.string "prompt_handle"
    t.string "digits"
    t.text "transcription"
    t.boolean "transcribed", default: false
    t.boolean "timeout", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "haiku"
    t.index ["created_at"], name: "index_responses_on_created_at"
    t.index ["digits"], name: "index_responses_on_digits"
    t.index ["phone_call_id", "prompt_handle"], name: "index_responses_on_phone_call_id_and_prompt_handle"
    t.index ["prompt_handle"], name: "index_responses_on_prompt_handle"
    t.index ["recording_id"], name: "index_responses_on_recording_id"
    t.index ["timeout"], name: "index_responses_on_timeout"
    t.index ["transcribed"], name: "index_responses_on_transcribed"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sms_conversations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "number"
    t.string "from_number"
    t.string "from_city"
    t.string "from_province"
    t.string "from_country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_sms_conversations_on_created_at"
    t.index ["from_number"], name: "index_sms_conversations_on_from_number"
    t.index ["number"], name: "index_sms_conversations_on_number"
  end

end
