class IndexController < ApplicationController
  caches_page :index

  def index
  end

  def sitemap
    @pages = Page.published.all
  end
end
