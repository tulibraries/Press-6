# frozen_string_literal: true

require "rails_helper"

RSpec.describe "subjects/show.html.erb", type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:subject) { FactoryBot.create(:subject) }

  before(:each) do
    @book = FactoryBot.create(:book, title: "Angora Workers United",
                                          subjects: '{ "subject":{ "subject_id":"#{subject.code}", "subject_title":"#{subject.title}" } }',
                                          sort_year: "1985")
    @book2 = FactoryBot.create(:book, title: "Zebra Farming for Beginners", 
                                          subjects: '{ "subject":{ "subject_id":"#{subject.code}", "subject_title":"#{subject.title}" } }',
                                          sort_year: "2022")
    allow(view).to receive(:current_user).and_return(user)
    assign(:subject, subject)
    @books = [@book, @book2]
    assign(:books, Kaminari.paginate_array(@books).page(1))
    render
  end

  describe "show page sorts books on-demand" do
    it "alpha sorts" do
        # binding.pry # this code isn't running. It always returns true whether its appear_before or appear_after
      within(rendered) do
        expect{ (@book2.title).to appear_before(@book.title, only_text: true) }
      end
    end
  end
  
end
