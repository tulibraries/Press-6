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

ActiveRecord::Schema[7.0].define(version: 2023_08_01_175038) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "service_name", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agencies", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "region"
    t.string "contact"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_agencies_on_slug", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.string "slug"
    t.string "author_id"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "prefix"
    t.string "suffix"
    t.boolean "suppress", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_authors_on_slug", unique: true
  end

  create_table "books", force: :cascade do |t|
    t.string "sort_year"
    t.string "sort_month"
    t.string "slug"
    t.boolean "add_to_news"
    t.boolean "active_guide"
    t.string "link_1"
    t.string "label_1"
    t.string "link_2"
    t.string "label_2"
    t.string "link_3"
    t.string "label_3"
    t.string "award_year"
    t.string "award_year2"
    t.string "award_year3"
    t.boolean "featured_award_winner"
    t.integer "featured_award_weight"
    t.string "excerpt"
    t.string "excerpt_file_name"
    t.string "xml_id"
    t.text "book_id"
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
    t.string "cover"
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
    t.string "suggested_reading_label"
    t.boolean "course_adoption"
    t.text "subjects"
    t.string "subject1"
    t.string "subject2"
    t.string "subject3"
    t.string "guide_file_label"
    t.string "qa_label"
    t.boolean "desk_copy"
    t.decimal "price", precision: 5, scale: 2
    t.string "series_id"
    t.string "catalog_id"
    t.text "author_ids"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "special_offer_id"
    t.string "cover_alt_text"
    t.boolean "suppress_from_view", default: false
    t.index ["catalog_id"], name: "index_books_on_catalog_id"
    t.index ["series_id"], name: "index_books_on_series_id"
    t.index ["slug"], name: "index_books_on_slug", unique: true
    t.index ["special_offer_id"], name: "index_books_on_special_offer_id"
  end

  create_table "brochures", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.boolean "promoted_to_homepage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "catalog_id"
    t.bigint "subject_id"
    t.index ["catalog_id"], name: "index_brochures_on_catalog_id"
    t.index ["slug"], name: "index_brochures_on_slug", unique: true
    t.index ["subject_id"], name: "index_brochures_on_subject_id"
  end

  create_table "catalog_brochures", force: :cascade do |t|
    t.integer "brochure_id"
    t.integer "catalog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brochure_id"], name: "index_catalog_brochures_on_brochure_id"
    t.index ["catalog_id"], name: "index_catalog_brochures_on_catalog_id"
  end

  create_table "catalogs", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "code"
    t.string "season"
    t.string "year"
    t.boolean "suppress", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_catalogs_on_slug", unique: true
  end

  create_table "conferences", force: :cascade do |t|
    t.string "dates"
    t.string "slug"
    t.string "title"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.string "link"
    t.string "venue"
    t.string "location"
    t.string "booth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_conferences_on_slug", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "contact_name"
    t.string "contact_email"
    t.string "document_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "person_id"
    t.index ["person_id"], name: "index_documents_on_person_id"
    t.index ["slug"], name: "index_documents_on_slug", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.integer "news_weight"
    t.string "slug"
    t.string "title"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.string "time_zone"
    t.string "location"
    t.boolean "add_to_news"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_events_on_slug", unique: true
  end

  create_table "faqs", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_faqs_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "highlights", force: :cascade do |t|
    t.string "alt_text"
    t.string "slug"
    t.string "title"
    t.boolean "promote_to_homepage"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_highlights_on_slug", unique: true
  end

  create_table "journals", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_journals_on_slug", unique: true
  end

  create_table "news_items", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "link"
    t.boolean "promote_to_homepage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_news_items_on_slug", unique: true
  end

  create_table "oabooks", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "subtitle"
    t.string "author"
    t.string "edition"
    t.string "isbn"
    t.string "print_isbn"
    t.string "collection"
    t.string "supplemental"
    t.boolean "pod"
    t.string "epub_link"
    t.string "manifold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_oabooks_on_slug", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "email"
    t.string "position"
    t.text "position_description"
    t.string "department"
    t.string "document_contact"
    t.boolean "head"
    t.string "phone"
    t.string "fax"
    t.string "coverage"
    t.string "company"
    t.string "region"
    t.string "website"
    t.boolean "is_rep", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "document_id"
    t.index ["document_id"], name: "index_people_on_document_id"
    t.index ["slug"], name: "index_people_on_slug", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.string "book_id"
    t.text "review"
    t.string "review_id"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "series", force: :cascade do |t|
    t.string "slug"
    t.string "code"
    t.string "title"
    t.string "editors"
    t.text "description"
    t.string "founder"
    t.string "image_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "book_id"
    t.boolean "unpublish", default: false
    t.index ["book_id"], name: "index_series_on_book_id"
    t.index ["slug"], name: "index_series_on_slug", unique: true
  end

  create_table "special_offer_books", force: :cascade do |t|
    t.integer "special_offer_id"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_special_offer_books_on_book_id"
    t.index ["special_offer_id"], name: "index_special_offer_books_on_special_offer_id"
  end

  create_table "special_offers", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "pdf_display_name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "book_id"
    t.index ["book_id"], name: "index_special_offers_on_book_id"
    t.index ["slug"], name: "index_special_offers_on_slug", unique: true
  end

  create_table "subject_brochures", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "brochure_id"
    t.bigint "subject_id"
    t.index ["brochure_id"], name: "index_subject_brochures_on_brochure_id"
    t.index ["subject_id"], name: "index_subject_brochures_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "slug"
    t.string "code"
    t.string "title"
    t.string "file_label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_subjects_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webpages", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_webpages_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "books", "special_offers"
  add_foreign_key "brochures", "catalogs"
  add_foreign_key "brochures", "subjects"
  add_foreign_key "documents", "people"
  add_foreign_key "people", "documents"
  add_foreign_key "series", "books"
  add_foreign_key "special_offers", "books"
end
