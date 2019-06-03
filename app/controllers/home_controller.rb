class HomeController < ApplicationController
  def index
    search = Document.search_for(params[:q] || '*')
    @documents = search.records
  end
end
