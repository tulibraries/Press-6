# frozen_string_literal: true

class DocumentsController < ApplicationController
  def index
    @documents_by_type = Document.all.group_by(&:document_type)
  end
end
