class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :book_id
      t.string :title
	  	t.string :subtitle
      t.text :author
      t.text :about_author
  		t.text :intro
	  	t.text :blurb
	  	t.text :excerpt_text
	  	t.text :in_series
	  	t.text :binding
	  	t.text :description
	  	t.text :reviews
	  	t.text :subjects
      t.text :contents
      t.text :author_id
      t.text :author_prefix
      t.text :author_first
      t.text :author_last
      t.text :author_suffix
      t.text :author_byline
      t.text :author_bios
	  	t.string :is_guide
      # t.text :is_guide_text HAS_RICH_TEXT in model
	  	t.string :cover_image
	  	t.string :format
	  	t.string :isbn
	  	t.string :ean
	  	t.string :pub_date
      t.string :pages_total
      t.string :trim
      t.string :illustrations
      t.string :award
      t.string :status
      # t.text :news_text HAS_RICH_TEXT in model
      t.integer :newsweight
      t.boolean :hot
      t.integer :hotweight
      t.boolean :course_adoption
      t.boolean :highlight
      t.string :catalog
      t.string :award_year
      t.string :sort_title
      t.string :supplement
      t.string :edition
      t.string :suggested_reading
      t.boolean :course_adoptions
      t.string :subject1
      t.string :subject2
      t.string :subject3
      t.string :award_year2
      t.string :award2
      t.string :award_year3
      t.string :award3
      t.string :award_year4
      t.string :award4

	  	t.numeric :price, :precision => 5, :scale => 2

      t.timestamps
    end
  end
end
