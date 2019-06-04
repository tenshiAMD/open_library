class HomeController < ApplicationController
  def index
    search = Document.search_for(search_params[:q] || "*")
    @documents = search.records
  end

  private

  def search_params
    params.permit(:q)
  end
end
