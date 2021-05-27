class OabooksController < ApplicationController
  before_action :set_oabook, only: [:show, :download_epub, :download_pdf, :download_mobi]

  def show
  end

  def north_broad_press
    @oabooks = Oabook.where(collection: "North Broad Press").order(:title)
    @total = @oabooks.count
    if @total.odd? || @total == 0
      @column_1 = @oabooks[0, ((@total / 2).floor + 1)]
    else
      @column_1 = @oabooks[0, (@total/2).floor]
    end
    @column_2 = @oabooks.reverse[0, (@total/2).floor]
    @page = Webpage.find_by_title("North Broad Press")
  end

  def labor_studies
    @oabooks = Oabook.where(collection: "Labor Studies & Work").order(:title)
    @total = @oabooks.count
    if @total.odd? || @total == 0
      @column_1 = @oabooks[0, ((@total / 2).floor + 1)]
    else
      @column_1 = @oabooks[0, (@total/2).floor]
    end
    @column_2 = @oabooks.reverse[0, (@total/2).floor]
    @page = Webpage.find_by_title("Labor Studies & Work")
  end

  def download_epub
    send_file(@oabook.epub.current_path,
        :filename => @oabook.epub.filename,
        :disposition => 'attachment',
        :url_based_filename => true)
  end

  def download_pdf
    send_file(@oabook.pdf.current_path,
        :filename => @oabook.pdf.filename,
        :disposition => 'attachment',
        :url_based_filename => true)
  end
  
  def download_mobi
    send_file(@oabook.mobi.current_path,
        :filename => @oabook.mobi.filename,
        :disposition => 'attachment',
        :url_based_filename => true)
  end

  private
    def set_oabook
      @oabook = Oabook.find_by(id: params[:id])
    end
end
