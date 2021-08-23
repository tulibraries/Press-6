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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2021_08_05_150544) do
=======
ActiveRecord::Schema.define(version: 2021_08_05_141843) do
>>>>>>> main

  create_table "action_text_rich_texts", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agencies", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "region"
    t.string "contact"
    t.string "address1"
    t.string "address2"
    t.string "address3"
    t.string "city"
    t.string "country"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.string "website"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "authors", charset: "utf8mb3", force: :cascade do |t|
    t.string "author_id"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "prefix"
    t.string "suffix"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "suppress", default: false
  end

  create_table "books", charset: "utf8mb3", force: :cascade do |t|
    t.string "xml_id"
    t.string "title"
    t.string "sort_title"
    t.string "subtitle"
    t.text "about_author"
    t.text "intro"
    t.text "blurb"
    t.text "excerpt_text"
    t.text "bindings"
    t.text "description"
    t.text "contents"
    t.text "author_byline"
    t.text "author_bios"
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
    t.decimal "price", precision: 5, scale: 2
    t.string "promotion_id"
    t.string "series_id"
    t.string "catalog_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "promotion_ids"
    t.text "author_ids"
    t.string "suggested_reading_label"
    t.bigint "special_offer_id"
    t.string "guide_file_label"
    t.string "cover"
    t.text "book_id"
    t.string "toc_label"
    t.boolean "desk_copy"
    t.boolean "featured_award_winner"
    t.string "excerpt"
    t.string "excerpt_file_name"
    t.string "link_1"
    t.string "label_1"
    t.string "link_2"
    t.string "label_2"
    t.string "link_3"
    t.string "label_3"
    t.string "award_year"
    t.string "award_year2"
    t.string "award_year3"
    t.string "link_4"
    t.string "link_5"
    t.string "link_6"
    t.string "link_7"
    t.string "link_8"
    t.string "link_9"
    t.string "link_10"
    t.string "label_4"
    t.string "label_5"
    t.string "label_6"
    t.string "label_7"
    t.string "label_8"
    t.string "label_9"
    t.string "label_10"
    t.boolean "active_guide"
    t.index ["catalog_id"], name: "index_books_on_catalog_id"
    t.index ["promotion_id"], name: "index_books_on_promotion_id"
    t.index ["series_id"], name: "index_books_on_series_id"
    t.index ["special_offer_id"], name: "index_books_on_special_offer_id"
  end

  create_table "brochures", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.boolean "promoted_to_homepage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalogs", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "code"
    t.string "season"
    t.string "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "suppress"
  end

  create_table "conferences", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "link"
    t.string "venue"
    t.string "location"
    t.string "booth"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "documents", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "contact_name"
    t.string "contact_email"
    t.string "document_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "person_id"
    t.index ["person_id"], name: "index_documents_on_person_id"
  end

  create_table "journals", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "oabooks", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.string "author"
    t.string "edition"
    t.string "isbn"
    t.string "print_isbn"
    t.string "collection"
    t.string "supplemental"
    t.boolean "pod"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "epub_link"
    t.string "manifold"
  end

  create_table "people", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "position"
    t.text "position_description"
    t.string "department"
    t.string "document_contact"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "head"
    t.bigint "document_id"
    t.string "phone"
    t.string "fax"
    t.string "coverage"
    t.string "company"
    t.string "region"
    t.string "website"
    t.boolean "is_rep", default: false
    t.index ["document_id"], name: "index_people_on_document_id"
  end

  create_table "promotions", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "pdf_display_name"
    t.boolean "active"
    t.text "book_ids"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", charset: "utf8mb3", force: :cascade do |t|
    t.string "book_id"
    t.text "review"
    t.string "review_id"
    t.integer "weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "series", charset: "utf8mb3", force: :cascade do |t|
    t.string "code"
    t.string "title"
    t.string "editors"
    t.text "description"
    t.string "founder"
    t.string "image_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "book_id"
    t.index ["book_id"], name: "index_series_on_book_id"
  end

  create_table "special_offers", charset: "utf8mb3", force: :cascade do |t|
    t.string "title"
    t.string "pdf_display_name"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "book_id"
    t.index ["book_id"], name: "index_special_offers_on_book_id"
  end

  create_table "subjects", charset: "utf8mb3", force: :cascade do |t|
    t.string "code"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "file_label"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webpages", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "books", "special_offers"
  add_foreign_key "documents", "people"
  add_foreign_key "people", "documents"
  add_foreign_key "series", "books"
  add_foreign_key "special_offers", "books"
end
