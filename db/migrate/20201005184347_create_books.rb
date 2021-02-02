# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :book_id
      t.string :title
      t.string :sort_title
      t.string :subtitle
      t.text :about_author
      t.text :intro
      t.text :blurb
      t.text :excerpt_text
      t.text :binding
      t.text :description
      t.text :contents
      t.text :author_byline
      t.text :author_bios
      t.string :cover_image
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
      t.string :suggested_reading
      t.boolean :course_adoption
      t.text :subjects
      t.string :subject1
      t.string :subject2
      t.string :subject3
      t.string :award_year
      t.string :award
      t.string :award_year2
      t.string :award2
      t.string :award_year3
      t.string :award3
      t.string :award_year4
      t.string :award4

      t.text :author_ids
      t.text :author_prefixes
      t.text :author_firsts
      t.text :author_lasts
      t.text :author_suffixes

      t.numeric :price, precision: 5, scale: 2

      t.string :promotion_id
      t.string :series_id
      t.string :catalog_id

      t.index(:series_id)
      t.index(:catalog_id)
      t.index(:promotion_id)

      t.timestamps
    end
  end
end
