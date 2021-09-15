# frozen_string_literal: true

module Admin
  class NewsItemsController < Admin::ApplicationController
    include Admin::Detachable
  end
end
