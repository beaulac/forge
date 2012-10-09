class IndexController < ApplicationController
  caches_page :index

  def index
    @page = Page.find_by_key("home")
    respond_to do |format|
      format.html {}
      format.mobile { render :template => "mobile/page" }
    end
  end

  def sitemap
    @pages = Page.published.all
  end
end
