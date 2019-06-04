class HomeController < ApplicationController
  def index
    search = Document.search_for(search_params[:q] || "*")
    @documents = search.records
  end

  def share
    @document = Document.find(share_params[:document_id])
    @document.share_later(share_params[:recipient], share_params[:message])
    flash[:success] = "Document shared successfully!"
    redirect_to root_path
  end

  private

  def search_params
    params.permit(:q)
  end

  def share_params
    params.permit(:document_id, :recipient, :message)
  end
end
