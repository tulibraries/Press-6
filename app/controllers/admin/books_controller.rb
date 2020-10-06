module Admin
  class BooksController < Admin::ApplicationController
    include Admin::Detachable
  end
end
