class HomeController < ApplicationController
  def index
    @documents = Document.all
  end
end
