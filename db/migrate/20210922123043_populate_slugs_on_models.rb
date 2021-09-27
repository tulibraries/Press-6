# frozen_string_literal: true

class PopulateSlugsOnModels < ActiveRecord::Migration[6.1]
  def change
    models = [Agency, Author, Book, Brochure, Catalog, Conference, Document, Event, Highlight, Journal, NewsItem, Oabook, Series, SpecialOffer, Subject, Webpage]

    models.each do |model|
      model.all.each do |m|
        m.save!
      end
    end
  end
end
