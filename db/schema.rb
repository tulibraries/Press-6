# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_02_141624) do

  create_table "action_text_rich_texts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "books", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "book_id"
    t.string "title"
    t.string "sort_title"
    t.string "subtitle"
    t.text "about_author"
    t.text "intro"
    t.text "blurb"
    t.text "excerpt_text"
    t.text "binding"
    t.text "description"
    t.text "contents"
    t.text "author_byline"
    t.text "author_bios"
    t.string "cover_image"
    t.string "format"
    t.string "isbn"
    t.string "ean"
    t.string "pub_date"
    t.string "pages_total"
    t.string "trim"
    t.string "illustrations"
    t.string "status"
    t.boolean "news"
    t.integer "newsweight"
    t.boolean "hot"
    t.integer "hotweight"
    t.string "supplement"
    t.string "edition"
    t.string "suggested_reading"
    t.boolean "course_adoption"
    t.text "subjects", size: :long
    t.string "subject1"
    t.string "subject2"
    t.string "subject3"
    t.string "award_year"
    t.string "award"
    t.string "award_year2"
    t.string "award2"
    t.string "award_year3"
    t.string "award3"
    t.string "award_year4"
    t.string "award4"
    t.decimal "price", precision: 5, scale: 2
    t.string "promotion_id"
    t.string "series_id"
    t.string "catalog_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "promotion_ids"
    t.text "author_ids"
    t.text "author_prefixes"
    t.text "author_firsts"
    t.text "author_lasts"
    t.text "author_suffixes"
    t.index ["catalog_id"], name: "index_books_on_catalog_id"
    t.index ["promotion_id"], name: "index_books_on_promotion_id"
    t.index ["series_id"], name: "index_books_on_series_id"
  end

  create_table "catalogs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.string "season"
    t.string "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "promotions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "pdf_display_name"
    t.boolean "active"
    t.text "book_ids"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "book_id"
    t.text "review"
    t.string "review_id"
    t.integer "weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "series", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "title"
    t.string "editors"
    t.text "description"
    t.string "founder"
    t.string "image_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subjects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "file_label"
  end

  create_table "webpages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
