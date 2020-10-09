module Admin
  class SubjectsController < Admin::ApplicationController
    include Admin::Detachable

    def default_sort
      { order: :title, direction: :asc }
    end
  end
end
