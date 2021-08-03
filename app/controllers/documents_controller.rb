class DocumentsController < ApplicationController

  def index
    @documents_by_type = Document.all.group_by { |t| t.document_type }
    # @documents_by_contact = @documents_by_type.map { |type, documents| binding.pry }  
  end

end
