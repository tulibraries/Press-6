# frozen_string_literal: true

class DocumentsController < ApplicationController
  def index
    @documents_by_type = Document.all.group_by { |t| t.document_type }
  end
end
