# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101114034628) do

  create_table "events", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "website"
    t.string   "promoter"
    t.date     "start_date",                    :null => false
    t.string   "end_date"
    t.string   "location"
    t.string   "state",                         :null => false
    t.boolean  "series",     :default => false
    t.string   "event_type",                    :null => false
    t.boolean  "featured",   :default => false
    t.string   "logo_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_type"], :name => "index_events_on_event_type"
  add_index "events", ["name"], :name => "index_events_on_name"
  add_index "events", ["state"], :name => "index_events_on_state"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_events", ["event_id"], :name => "index_user_events_on_event_id"
  add_index "user_events", ["user_id"], :name => "index_user_events_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :null => false
    t.string   "first_name",                          :null => false
    t.string   "last_name",                           :null => false
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "role",            :default => "user"
    t.string   "address"
    t.string   "address_1"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country",         :default => "USA"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
