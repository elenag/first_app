# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120831203353) do

  create_table "accounts", :force => true do |t|
    t.string   "acc_number"
    t.integer  "school_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "homeroom_id"
    t.string   "status"
    t.integer  "number_broken"
    t.boolean  "flagged"
    t.text     "comments"
  end

  add_index "accounts", ["homeroom_id", "school_id"], :name => "index_accounts_on_homeroom_id_and_school_id"

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "can_edit_origins"
    t.boolean  "ops_rel"
    t.boolean  "publishing_rel"
    t.boolean  "DR_rel"
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "admin_users_projects", :id => false, :force => true do |t|
    t.integer "admin_user_id"
    t.integer "project_id"
  end

  add_index "admin_users_projects", ["admin_user_id", "project_id"], :name => "admin_user_project_index", :unique => true

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.integer  "origin_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "comments"
  end

  add_index "authors", ["origin_id"], :name => "index_authors_on_origin_id"

  create_table "authors_books", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "author_id"
  end

  add_index "authors_books", ["book_id", "author_id"], :name => "index_authors_books_on_book_id_and_author_id"

  create_table "books", :force => true do |t|
    t.string   "asin"
    t.string   "title"
    t.decimal  "price"
    t.integer  "rating"
    t.boolean  "flagged",             :default => false
    t.boolean  "copublished"
    t.integer  "publisher_id"
    t.integer  "language_id"
    t.integer  "genre_id"
    t.text     "comments"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.date     "date_added"
    t.string   "status"
    t.boolean  "restricted"
    t.string   "appstatus"
    t.integer  "limited"
    t.integer  "fiction_type_id"
    t.integer  "textbook_level_id"
    t.integer  "textbook_subject_id"
  end

  add_index "books", ["language_id", "publisher_id", "genre_id"], :name => "altered_books_language_publisher_genre_index", :unique => true

  create_table "books_content_buckets", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "content_bucket_id"
  end

  add_index "books_content_buckets", ["book_id", "content_bucket_id"], :name => "index_books_content_buckets_on_book_id_and_content_bucket_id"

  create_table "books_levels", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "level_id"
  end

  add_index "books_levels", ["book_id", "level_id"], :name => "index_books_levels_on_book_id_and_level_id"

  create_table "books_platforms", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "platform_id"
  end

  add_index "books_platforms", ["book_id", "platform_id"], :name => "index_books_platforms_on_book_id_and_platform_id"

  create_table "books_publishing_rights", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "publishing_right_id"
  end

  add_index "books_publishing_rights", ["book_id", "publishing_right_id"], :name => "book_publishing_right_index", :unique => true

  create_table "content_buckets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
  end

  create_table "content_buckets_homerooms", :id => false, :force => true do |t|
    t.integer "content_bucket_id"
    t.integer "homeroom_id"
  end

  add_index "content_buckets_homerooms", ["content_bucket_id", "homeroom_id"], :name => "content_bucket_homeroom_index", :unique => true

  create_table "continents", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "device_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "devices", :force => true do |t|
    t.string   "serial_number"
    t.boolean  "flagged",           :default => false
    t.integer  "control"
    t.boolean  "reinforced_screen", :default => false
    t.integer  "device_type_id"
    t.integer  "account_id"
    t.integer  "purchase_order_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "status"
    t.string   "return_reason"
    t.text     "comments"
    t.string   "action"
  end

  add_index "devices", ["account_id", "purchase_order_id", "device_type_id"], :name => "device_account_po_dt_index"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "device_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "events", ["device_id"], :name => "index_events_on_device_id"

  create_table "fiction_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "homerooms", :force => true do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "homerooms", ["school_id"], :name => "index_homerooms_on_school_id"

  create_table "homerooms_content_buckets", :id => false, :force => true do |t|
    t.integer "content_bucket_id"
    t.integer "homeroom_id"
  end

  add_index "homerooms_content_buckets", ["homeroom_id", "content_bucket_id"], :name => "homeroom_content_bucket_index", :unique => true

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "models", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "origins", :force => true do |t|
    t.string   "name"
    t.integer  "continent_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "origins", ["continent_id"], :name => "index_origins_on_continent_id"

  create_table "platforms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "model_id"
    t.integer  "origin_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "target_size"
    t.integer  "current_size"
    t.text     "comments"
    t.integer  "admin_user_id"
    t.integer  "project_type_id"
  end

  add_index "projects", ["origin_id", "model_id"], :name => "index_projects_on_origin_id_and_model_id"

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.integer  "origin_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "publishers", ["origin_id"], :name => "index_publishers_on_origin_id"

  create_table "publishing_rights", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "purchase_orders", :force => true do |t|
    t.string   "po_number"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.date     "date_ordered"
    t.date     "warranty_end_date"
    t.integer  "project_id"
    t.text     "comments"
  end

  create_table "pushes", :force => true do |t|
    t.integer  "book_id"
    t.integer  "content_bucket_id"
    t.date     "push_date"
    t.boolean  "successful"
    t.text     "comments"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "pushes", ["book_id", "content_bucket_id"], :name => "index_pushes_on_book_id_and_content_bucket_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "schools", ["project_id"], :name => "index_schools_on_project_id"

  create_table "students", :force => true do |t|
    t.string   "first_name"
    t.string   "other_names"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "account_id"
    t.text     "comments"
    t.string   "role"
  end

  add_index "students", ["account_id"], :name => "index_students_on_account_id", :unique => true

  create_table "textbook_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "textbook_subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
