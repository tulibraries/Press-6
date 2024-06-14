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
    t.string "name", limit: 255, null: false
    t.text "body"
    t.string "record_type", limit: 255, null: false
    t.bigint "record_id", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "idx_19018_index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "record_type", limit: 255, null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.timestamptz "created_at", null: false
    t.index ["blob_id"], name: "idx_19025_index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "idx_19025_index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", limit: 255, null: false
    t.string "filename", limit: 255, null: false
    t.string "content_type", limit: 255
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", limit: 255, null: false
    t.timestamptz "created_at", null: false
    t.string "service_name", limit: 255, null: false
    t.index ["key"], name: "idx_19032_index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", limit: 255, null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["blob_id", "variation_digest"], name: "idx_19040_index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agencies", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "region", limit: 255
    t.string "contact", limit: 255
    t.string "phone", limit: 255
    t.string "fax", limit: 255
    t.string "email", limit: 255
    t.string "website", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "slug", limit: 255
    t.index ["slug"], name: "idx_19045_index_agencies_on_slug", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.string "author_id", limit: 255
    t.string "title", limit: 255
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "prefix", limit: 255
    t.string "suffix", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.boolean "suppress", default: false
    t.string "slug", limit: 255
    t.index ["slug"], name: "idx_19066_index_authors_on_slug", unique: true
  end

  create_table "books", force: :cascade do |t|
    t.string "xml_id", limit: 255
    t.string "title", limit: 255
    t.string "sort_title", limit: 255
    t.string "subtitle", limit: 255
    t.text "about_author"
    t.text "intro"
    t.text "blurb"
    t.text "excerpt_text"
    t.text "bindings"
    t.text "description"
    t.text "contents"
    t.text "author_byline"
    t.text "author_bios"
    t.string "format", limit: 255
    t.string "isbn", limit: 255
    t.string "ean", limit: 255
    t.string "pub_date", limit: 255
    t.string "pages_total", limit: 255
    t.string "trim", limit: 255
    t.string "illustrations", limit: 255
    t.string "status", limit: 255
    t.boolean "news"
    t.bigint "newsweight"
    t.boolean "hot"
    t.bigint "hotweight"
    t.string "supplement", limit: 255
    t.string "edition", limit: 255
    t.string "suggested_reading", limit: 255
    t.boolean "course_adoption"
    t.text "subjects"
    t.string "subject1", limit: 255
    t.string "subject2", limit: 255
    t.string "subject3", limit: 255
    t.decimal "price", precision: 5, scale: 2
    t.string "promotion_id", limit: 255
    t.string "series_id", limit: 255
    t.string "catalog_id", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.text "promotion_ids"
    t.text "author_ids"
    t.string "suggested_reading_label", limit: 255
    t.bigint "special_offer_id"
    t.string "guide_file_label", limit: 255
    t.string "cover", limit: 255
    t.text "book_id"
    t.string "qa_label", limit: 255
    t.boolean "desk_copy"
    t.boolean "featured_award_winner"
    t.string "excerpt", limit: 255
    t.string "excerpt_file_name", limit: 255
    t.string "link_1", limit: 255
    t.string "label_1", limit: 255
    t.string "link_2", limit: 255
    t.string "label_2", limit: 255
    t.string "link_3", limit: 255
    t.string "label_3", limit: 255
    t.string "award_year", limit: 255
    t.string "award_year2", limit: 255
    t.string "award_year3", limit: 255
    t.string "link_4", limit: 255
    t.string "link_5", limit: 255
    t.string "link_6", limit: 255
    t.string "link_7", limit: 255
    t.string "link_8", limit: 255
    t.string "link_9", limit: 255
    t.string "link_10", limit: 255
    t.string "label_4", limit: 255
    t.string "label_5", limit: 255
    t.string "label_6", limit: 255
    t.string "label_7", limit: 255
    t.string "label_8", limit: 255
    t.string "label_9", limit: 255
    t.string "label_10", limit: 255
    t.boolean "active_guide"
    t.boolean "add_to_news"
    t.string "slug", limit: 255
    t.string "sort_year", limit: 255
    t.string "sort_month", limit: 255
    t.bigint "featured_award_weight"
    t.string "cover_alt_text", limit: 255
    t.boolean "suppress_from_view", default: false
    t.index ["catalog_id"], name: "idx_19081_index_books_on_catalog_id"
    t.index ["promotion_id"], name: "idx_19081_index_books_on_promotion_id"
    t.index ["series_id"], name: "idx_19081_index_books_on_series_id"
    t.index ["slug"], name: "idx_19081_index_books_on_slug", unique: true
    t.index ["special_offer_id"], name: "idx_19081_index_books_on_special_offer_id"
  end

  create_table "brochures", force: :cascade do |t|
    t.string "title", limit: 255
    t.boolean "promoted_to_homepage"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.bigint "catalog_id"
    t.bigint "subject_id"
    t.string "slug", limit: 255
    t.index ["catalog_id"], name: "idx_19144_index_brochures_on_catalog_id"
    t.index ["slug"], name: "idx_19144_index_brochures_on_slug", unique: true
    t.index ["subject_id"], name: "idx_19144_index_brochures_on_subject_id"
  end

  create_table "catalog_brochures", force: :cascade do |t|
    t.bigint "brochure_id"
    t.bigint "catalog_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["brochure_id"], name: "idx_19166_index_catalog_brochures_on_brochure_id"
    t.index ["catalog_id"], name: "idx_19166_index_catalog_brochures_on_catalog_id"
  end

  create_table "catalogs", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "code", limit: 255
    t.string "season", limit: 255
    t.string "year", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.boolean "suppress", default: true
    t.string "slug", limit: 255
    t.index ["slug"], name: "idx_19153_index_catalogs_on_slug", unique: true
  end

  create_table "conferences", force: :cascade do |t|
    t.string "title", limit: 255
    t.timestamptz "start_date"
    t.timestamptz "end_date"
    t.string "link", limit: 255
    t.string "venue", limit: 255
    t.string "location", limit: 255
    t.string "booth", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "slug", limit: 255
    t.string "dates", limit: 255
    t.index ["slug"], name: "idx_19171_index_conferences_on_slug", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "contact_name", limit: 255
    t.string "contact_email", limit: 255
    t.string "document_type", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.bigint "person_id"
    t.string "slug", limit: 255
    t.index ["person_id"], name: "idx_19185_index_documents_on_person_id"
    t.index ["slug"], name: "idx_19185_index_documents_on_slug", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "title", limit: 255
    t.timestamptz "start_date"
    t.timestamptz "end_date"
    t.string "time_zone", limit: 255
    t.string "location", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.boolean "add_to_news"
    t.string "slug", limit: 255
    t.bigint "news_weight"
    t.index ["slug"], name: "idx_19197_index_events_on_slug", unique: true
  end

  create_table "faqs", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "slug", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["slug"], name: "idx_19208_index_faqs_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", limit: 255, null: false
    t.bigint "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope", limit: 255
    t.timestamptz "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "idx_19217_index_friendly_id_slugs_on_slug_and_sluggable_type_an", unique: true
    t.index ["slug", "sluggable_type"], name: "idx_19217_index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "idx_19217_index_friendly_id_slugs_on_sluggable_type_and_sluggab"
  end

  create_table "highlights", force: :cascade do |t|
    t.string "title", limit: 255
    t.boolean "promote_to_homepage"
    t.string "link", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "slug", limit: 255
    t.string "alt_text", limit: 255
    t.index ["slug"], name: "idx_19226_index_highlights_on_slug", unique: true
  end

  create_table "journals", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "url", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "slug", limit: 255
    t.index ["slug"], name: "idx_19237_index_journals_on_slug", unique: true
  end

  create_table "news_items", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "link", limit: 255
    t.boolean "promote_to_homepage"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "slug", limit: 255
    t.index ["slug"], name: "idx_19247_index_news_items_on_slug", unique: true
  end

  create_table "oabooks", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "subtitle", limit: 255
    t.string "author", limit: 255
    t.string "edition", limit: 255
    t.string "isbn", limit: 255
    t.string "print_isbn", limit: 255
    t.string "collection", limit: 255
    t.string "supplemental", limit: 255
    t.boolean "pod"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "epub_link", limit: 255
    t.string "manifold", limit: 255
    t.string "slug", limit: 255
    t.index ["slug"], name: "idx_19257_index_oabooks_on_slug", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "email", limit: 255
    t.string "position", limit: 255
    t.text "position_description"
    t.string "department", limit: 255
    t.string "document_contact", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.boolean "head"
    t.bigint "document_id"
    t.string "phone", limit: 255
    t.string "fax", limit: 255
    t.string "coverage", limit: 255
    t.string "company", limit: 255
    t.string "region", limit: 255
    t.string "website", limit: 255
    t.boolean "is_rep", default: false
    t.string "slug", limit: 255
    t.index ["document_id"], name: "idx_19275_index_people_on_document_id"
    t.index ["slug"], name: "idx_19275_index_people_on_slug", unique: true
  end

  create_table "promotions", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "pdf_display_name", limit: 255
    t.boolean "active"
    t.text "book_ids"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string "book_id", limit: 255
    t.text "review"
    t.string "review_id", limit: 255
    t.bigint "weight"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
  end

  create_table "series", force: :cascade do |t|
    t.string "code", limit: 255
    t.string "title", limit: 255
    t.string "editors", limit: 255
    t.text "description"
    t.string "founder", limit: 255
    t.string "image_link", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.bigint "book_id"
    t.string "slug", limit: 255
    t.boolean "unpublish", default: false
    t.index ["book_id"], name: "idx_19316_index_series_on_book_id"
    t.index ["slug"], name: "idx_19316_index_series_on_slug", unique: true
  end

  create_table "special_offer_books", force: :cascade do |t|
    t.bigint "special_offer_id"
    t.bigint "book_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["book_id"], name: "idx_19340_index_special_offer_books_on_book_id"
    t.index ["special_offer_id"], name: "idx_19340_index_special_offer_books_on_special_offer_id"
  end

  create_table "special_offers", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "pdf_display_name", limit: 255
    t.boolean "active"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.bigint "book_id"
    t.string "slug", limit: 255
    t.index ["book_id"], name: "idx_19330_index_special_offers_on_book_id"
    t.index ["slug"], name: "idx_19330_index_special_offers_on_slug", unique: true
  end

  create_table "subject_brochures", force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.bigint "brochure_id"
    t.bigint "subject_id"
    t.index ["brochure_id"], name: "index_subject_brochures_on_brochure_id"
    t.index ["subject_id"], name: "index_subject_brochures_on_subject_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "code", limit: 255
    t.string "title", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "file_label", limit: 255
    t.string "slug", limit: 255
    t.index ["slug"], name: "idx_19345_index_subjects_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.timestamptz "reset_password_sent_at"
    t.timestamptz "remember_created_at"
    t.bigint "sign_in_count", default: 0, null: false
    t.timestamptz "current_sign_in_at"
    t.timestamptz "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["email"], name: "idx_19361_index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "idx_19361_index_users_on_reset_password_token", unique: true
  end

  create_table "webpages", force: :cascade do |t|
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.string "title", limit: 255
    t.string "slug", limit: 255
    t.index ["slug"], name: "idx_19374_index_webpages_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "books", "special_offers", on_update: :restrict, on_delete: :restrict
  add_foreign_key "brochures", "catalogs", on_update: :restrict, on_delete: :restrict
  add_foreign_key "brochures", "subjects", on_update: :restrict, on_delete: :restrict
  add_foreign_key "documents", "people", on_update: :restrict, on_delete: :restrict
  add_foreign_key "people", "documents", on_update: :restrict, on_delete: :restrict
  add_foreign_key "series", "books", on_update: :restrict, on_delete: :restrict
  add_foreign_key "special_offers", "books", on_update: :restrict, on_delete: :restrict
end
