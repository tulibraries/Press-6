# frozen_string_literal: true

module Admin
  class BooksController < Admin::ApplicationController
    include Admin::Detachable

    def default_sort
      { order: :title, direction: :asc }
    end
  end
end
