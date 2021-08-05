# frozen_string_literal: true

module Admin
  class AuthorsController < Admin::ApplicationController
    def default_sort
      { order: :title, direction: :asc }
    end
  end
end
