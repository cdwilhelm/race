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

ActiveRecord::Schema.define(:version => 20110514154544) do

  create_table "categories", :force => true do |t|
    t.integer  "registration_id"
    t.string   "name"
    t.decimal  "fee",             :precision => 5, :scale => 2, :default => 0.0
    t.integer  "field_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["registration_id"], :name => "fk_categories_registration_id"

  create_table "event_comments", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_comments", ["event_id"], :name => "fk_event_comments_event_id"
  add_index "event_comments", ["user_id"], :name => "fk_event_comments_user_id"

  create_table "events", :force => true do |t|
    t.string   "name",                            :null => false
    t.string   "website"
    t.string   "promoter"
    t.date     "start_date",                      :null => false
    t.date     "end_date"
    t.string   "venue_location"
    t.string   "city",                            :null => false
    t.string   "zip_code"
    t.string   "state",                           :null => false
    t.string   "series",         :default => ""
    t.string   "event_type",                      :null => false
    t.string   "featured",       :default => "n"
    t.string   "logo_path"
    t.integer  "user_id",                         :null => false
    t.float    "lat"
    t.float    "lng"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_type"], :name => "index_events_on_event_type"
  add_index "events", ["name"], :name => "index_events_on_name"
  add_index "events", ["state"], :name => "index_events_on_state"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "registrations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "address"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "email"
    t.string   "emergency_contact"
    t.string   "emergency_contact_phone"
    t.string   "club"
    t.date     "birth_date"
    t.string   "license"
    t.decimal  "fee",                     :precision => 5, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registrations", ["event_id"], :name => "fk_registrations_event_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email",                                                     :null => false
    t.string   "first_name",                                                :null => false
    t.string   "last_name",                                                 :null => false
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "role",                                  :default => "user"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "country",                               :default => "USA"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname",                :limit => 10
    t.string   "opt_in",                  :limit => 1,  :default => "y"
    t.float    "lat"
    t.float    "lng"
    t.date     "birth_date"
    t.string   "emergency_contact"
    t.string   "emergency_contact_phone"
    t.string   "license"
    t.string   "club"
    t.string   "reset_code",              :limit => 40
    t.string   "activation_code",         :limit => 40
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["lat", "lng"], :name => "index_users_on_lat_and_lng"

end
