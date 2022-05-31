# frozen_string_literal: true

class CreateStructure < ActiveRecord::Migration[6.1]
  def change
    unless table_exists?(:active_storage_blobs)
      create_table :active_storage_blobs do |t|
        t.string   :key,          null: false
        t.string   :filename,     null: false
        t.string   :service_name, null: false
        t.string   :content_type
        t.text     :metadata
        t.bigint   :byte_size,    null: false
        t.string   :checksum,     null: false
        t.datetime :created_at,   null: false
      end
    end

    unless table_exists?(:active_storage_variant_records)
      create_table :active_storage_variant_records do |t|
        t.belongs_to :blob, null: false, index: false, type: :bigint
        t.string :variation_digest, null: false

        t.timestamps
      end
    end

    unless table_exists?(:active_storage_attachments)
      create_table :active_storage_attachments do |t|
        t.string     :name,     null: false
        t.references :record,   null: false, polymorphic: true, index: false
        t.references :blob,     null: false

        t.datetime :created_at, null: false
      end
    end

    unless table_exists?(:action_text_rich_texts)
      create_table :action_text_rich_texts do |t|
        t.string     :name, null: false
        t.text       :body, size: :long
        t.references :record, null: false, polymorphic: true, index: false

        t.timestamps
      end
    end

    unless table_exists?(:agencies)
      create_table :agencies do |t|
        t.string :slug
        t.string :title
        t.string :region
        t.string :contact
        t.string :phone
        t.string :fax
        t.string :email
        t.string :website

        t.timestamps
      end
    end

    unless table_exists?(:authors)
      create_table :authors do |t|
        t.string :slug
        t.string :author_id
        t.string :title
        t.string :first_name
        t.string :last_name
        t.string :prefix
        t.string :suffix
        t.boolean :suppress, default: false

        t.timestamps
      end
    end

    unless table_exists?(:books)
      create_table :books do |t|
        t.string :sort_year
        t.string :sort_month
        t.string :slug
        t.boolean :add_to_news
        t.boolean :active_guide
        t.string :link_1
        t.string :label_1
        t.string :link_2
        t.string :label_2
        t.string :link_3
        t.string :label_3
        t.string :award_year
        t.string :award_year2
        t.string :award_year3
        t.boolean :featured_award_winner
        t.integer :featured_award_weight
        t.string :excerpt
        t.string :excerpt_file_name
        t.string :xml_id
        t.text :book_id
        t.string :title
        t.string :sort_title
        t.string :subtitle
        t.text :about_author
        t.text :intro
        t.text :blurb
        t.text :excerpt_text
        t.text :bindings
        t.text :description
        t.text :contents
        t.text :author_byline
        t.text :author_bios
        t.string :cover
        t.string :format
        t.string :isbn
        t.string :ean
        t.string :pub_date
        t.string :pages_total
        t.string :trim
        t.string :illustrations
        t.string :status
        t.boolean :news
        t.integer :newsweight
        t.boolean :hot
        t.integer :hotweight
        t.string :supplement
        t.string :edition
        t.string :suggested_reading_label
        t.boolean :course_adoption
        t.text :subjects
        t.string :subject1
        t.string :subject2
        t.string :subject3
        t.string :guide_file_label
        t.string :qa_label
        t.boolean :desk_copy
        t.numeric :price, precision: 5, scale: 2
        t.string :series_id
        t.string :catalog_id
        t.text :author_ids
        t.string :link_4
        t.string :link_5
        t.string :link_6
        t.string :link_7
        t.string :link_8
        t.string :link_9
        t.string :link_10
        t.string :label_4
        t.string :label_5
        t.string :label_6
        t.string :label_7
        t.string :label_8
        t.string :label_9
        t.string :label_10

        t.timestamps
      end
    end

    unless table_exists?(:brochures)
      create_table :brochures do |t|
        t.string :slug
        t.string :title
        t.boolean :promoted_to_homepage

        t.timestamps
      end
    end

    unless table_exists?(:catalogs)
      create_table :catalogs do |t|
        t.string :slug
        t.string :title
        t.string :code
        t.string :season
        t.string :year
        t.boolean :suppress

        t.timestamps
      end
    end

    unless table_exists?(:catalog_brochures)
      create_table :catalog_brochures do |t|
        t.integer :brochure_id
        t.integer :catalog_id

        t.timestamps
      end
    end

    unless table_exists?(:conferences)
      create_table :conferences do |t|
        t.string :dates
        t.string :slug
        t.string :title
        t.datetime :start_date
        t.datetime :end_date
        t.string :link
        t.string :venue
        t.string :location
        t.string :booth

        t.timestamps
      end
    end

    unless table_exists?(:documents)
      create_table :documents do |t|
        t.string :slug
        t.string :title
        t.string :contact_name
        t.string :contact_email
        t.string :document_type

        t.timestamps
      end
    end

    unless table_exists?(:events)
      create_table :events do |t|
        t.integer :news_weight
        t.string :slug
        t.string :title
        t.datetime :start_date
        t.datetime :end_date
        t.string :time_zone
        t.string :location
        t.boolean :add_to_news

        t.timestamps
      end
    end

    unless table_exists?(:faqs)
      create_table :faqs do |t|
        t.string :title
        t.string :slug
        t.timestamps
      end
    end

    unless table_exists?(:highlights)
      create_table :highlights do |t|
        t.string :alt_text
        t.string :slug
        t.string :title
        t.boolean :promote_to_homepage
        t.string :link

        t.timestamps
      end
    end

    unless table_exists?(:journals)
      create_table :journals do |t|
        t.string :slug
        t.string :title
        t.string :url

        t.timestamps
      end
    end

    unless table_exists?(:news_items)
      create_table :news_items do |t|
        t.string :slug
        t.string :title
        t.string :link
        t.boolean :promote_to_homepage

        t.timestamps
      end
    end

    unless table_exists?(:oabooks)
      create_table :oabooks do |t|
        t.string :slug
        t.string :title
        t.string :subtitle
        t.string :author
        t.string :edition
        t.string :isbn
        t.string :print_isbn
        t.string :collection
        t.string :supplemental
        t.boolean :pod
        t.string :epub_link
        t.string :manifold

        t.timestamps
      end
    end

    unless table_exists?(:people)
      create_table :people do |t|
        t.string :slug
        t.string :title
        t.string :email
        t.string :position
        t.text :position_description
        t.string :department
        t.string :document_contact
        t.boolean :head
        t.string :phone
        t.string :fax
        t.string :coverage
        t.string :company
        t.string :region
        t.string :website
        t.boolean :is_rep, default: false

        t.timestamps
      end
    end

    unless table_exists?(:reviews)
      create_table :reviews do |t|
        t.string :book_id
        t.text   :review
        t.string :review_id
        t.integer :weight

        t.timestamps
      end
    end

    unless table_exists?(:series)
      create_table :series do |t|
        t.string  :slug
        t.string  :code
        t.string  :title
        t.string  :editors
        t.text    :description
        t.string  :founder
        t.string  :image_link

        t.timestamps
      end
    end

    unless table_exists?(:special_offers)
      create_table :special_offers do |t|
        t.string :slug
        t.string :title
        t.string :pdf_display_name
        t.boolean :active

        t.timestamps
      end
    end

    unless table_exists?(:special_offer_books)
      create_table :special_offer_books do |t|
        t.integer :special_offer_id
        t.integer :book_id

        t.timestamps
      end
    end

    unless table_exists?(:subjects)
      create_table :subjects do |t|
        t.string :slug
        t.string :code
        t.string :title
        t.string :file_label

        t.timestamps
      end
    end

    unless table_exists?(:subject_brochures)
      create_table :subject_brochures do |t|
        t.integer :brochure_id
        t.integer :subject_id

        t.timestamps
      end
    end

    unless table_exists?(:webpages)
      create_table :webpages do |t|
        t.string :slug
        t.string :title
        t.timestamps
      end
    end

    unless table_exists?(:users)
      create_table :users, bulk: true do |t|
        ## Database authenticatable
        t.string :email,              null: false, default: ""
        t.string :encrypted_password, null: false, default: ""

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        ## Trackable
        t.integer  :sign_in_count, default: 0, null: false
        t.datetime :current_sign_in_at
        t.datetime :last_sign_in_at
        t.string   :current_sign_in_ip
        t.string   :last_sign_in_ip

        ## Confirmable
        # t.string   :confirmation_token
        # t.datetime :confirmed_at
        # t.datetime :confirmation_sent_at
        # t.string   :unconfirmed_email # Only if using reconfirmable

        ## Lockable
        # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
        # t.string   :unlock_token # Only if unlock strategy is :email or :both
        # t.datetime :locked_at

        t.timestamps null: false

        t.index :email, unique: true
        t.index :reset_password_token, unique: true
        # add_index :users, :confirmation_token,   unique: true
        # add_index :users, :unlock_token,         unique: true
      end
    end

    unless table_exists?(:friendly_id_slugs)
      create_table :friendly_id_slugs do |t|
        t.string   :slug,           null: false
        t.integer  :sluggable_id,   null: false
        t.string   :sluggable_type, limit: 50
        t.string   :scope
        t.datetime :created_at
      end
    end

    unless foreign_key_exists?(:active_storage_attachments, :active_storage_blobs)
      add_foreign_key :active_storage_attachments, :active_storage_blobs, column: :blob_id
    end
    unless foreign_key_exists?(:active_storage_variant_records, :active_storage_blobs)
      add_foreign_key :active_storage_variant_records, :active_storage_blobs, column: :blob_id
    end

    add_reference :special_offers, :book, foreign_key: true unless index_exists?(:special_offers, :book_id)
    add_reference :books, :special_offer, foreign_key: true unless index_exists?(:books, :special_offer_id)
    add_reference :brochures, :catalog, foreign_key: true unless index_exists?(:brochures, :catalog_id)
    add_reference :brochures, :subject, foreign_key: true unless index_exists?(:brochures, :subject_id)
    add_reference :documents, :person, foreign_key: true unless index_exists?(:documents, :person_id)
    add_reference :people, :document, foreign_key: true unless index_exists?(:people, :document_id)
    add_reference :series, :book, foreign_key: true unless index_exists?(:series, :book_id)

    unless index_exists?(:active_storage_variant_records, %i[blob_id variation_digest],
                         name: "index_active_storage_variant_records_uniqueness")
      add_index :active_storage_variant_records, %i[blob_id variation_digest],
                name: "index_active_storage_variant_records_uniqueness", unique: true
    end
    unless index_exists?(:action_text_rich_texts, %i[record_type record_id name],
                         name: "index_action_text_rich_texts_uniqueness")
      add_index :action_text_rich_texts, %i[record_type record_id name],
                name: "index_action_text_rich_texts_uniqueness", unique: true
    end
    unless index_exists?(:active_storage_attachments, %i[record_type record_id name blob_id],
                         name: "index_active_storage_attachments_uniqueness")
      add_index :active_storage_attachments, %i[record_type record_id name blob_id],
                name: "index_active_storage_attachments_uniqueness", unique: true
    end
    add_index :active_storage_blobs, [:key], unique: true unless index_exists?(:active_storage_blobs, :key)

    unless index_exists?(:books, :series_id) && index_exists?(:books, :catalog_id)
      change_table :books, bulk: true do |t|
        t.index :series_id
        t.index :catalog_id
      end
    end

    unless index_exists?(:catalog_brochures, :brochure_id) && index_exists?(:catalog_brochures, :catalog_id)
      change_table :catalog_brochures, bulk: true do |t|
        t.index :brochure_id
        t.index :catalog_id
      end
    end

    unless index_exists?(:special_offer_books, :special_offer_id) && index_exists?(:special_offer_books, :book_id)
      change_table :special_offer_books, bulk: true do |t|
        t.index :special_offer_id
        t.index :book_id
      end
    end

    unless index_exists?(:subject_brochures, :brochure_id) && index_exists?(:subject_brochures, :subject_id)
      change_table :subject_brochures, bulk: true do |t|
        t.index :brochure_id, unique: true
        t.index :subject_id, unique: true
      end
    end

    unless index_exists?(:friendly_id_slugs,
                         %i[sluggable_type
                            sluggable_id]) && index_exists?(:friendly_id_slugs,
                                                            %i[slug
                                                               sluggable_type]) && index_exists?(:friendly_id_slugs,
                                                                                                 %i[slug sluggable_type
                                                                                                    scope])
      change_table :friendly_id_slugs, bulk: true do |t|
        t.index %i[sluggable_type sluggable_id]
        t.index %i[slug sluggable_type], length: { slug: 140, sluggable_type: 50 }
        t.index %i[slug sluggable_type scope], length: { slug: 70, sluggable_type: 50, scope: 70 }, unique: true
      end
    end

    add_index :agencies, :slug, unique: true unless index_exists?(:agencies, :slug)
    add_index :authors, :slug, unique: true unless index_exists?(:authors, :slug)
    add_index :books, :slug, unique: true unless index_exists?(:books, :slug)
    add_index :brochures, :slug, unique: true unless index_exists?(:brochures, :slug)
    add_index :catalogs, :slug, unique: true unless index_exists?(:catalogs, :slug)
    add_index :conferences, :slug, unique: true unless index_exists?(:conferences, :slug)
    add_index :documents, :slug, unique: true unless index_exists?(:documents, :slug)
    add_index :events, :slug, unique: true unless index_exists?(:events, :slug)
    add_index :faqs, :slug, unique: true unless index_exists?(:faqs, :slug)
    add_index :highlights, :slug, unique: true unless index_exists?(:highlights, :slug)
    add_index :journals, :slug, unique: true unless index_exists?(:journals, :slug)
    add_index :news_items, :slug, unique: true unless index_exists?(:news_items, :slug)
    add_index :oabooks, :slug, unique: true unless index_exists?(:oabooks, :slug)
    add_index :people, :slug, unique: true unless index_exists?(:people, :slug)
    add_index :series, :slug, unique: true unless index_exists?(:series, :slug)
    add_index :special_offers, :slug, unique: true unless index_exists?(:special_offers, :slug)
    add_index :subjects, :slug, unique: true unless index_exists?(:subjects, :slug)
    add_index :webpages, :slug, unique: true unless index_exists?(:webpages, :slug)
  end
end
