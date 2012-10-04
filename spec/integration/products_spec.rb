require 'spec_helper'

describe 'A product' do
  fixtures :products
  
  context 'being viewed by a search engine' do
    before do
      @product = products(:with_seo)
    end

    it "should contain the SEO fields" do
      visit product_path(@product)
      within('head title') { page.should have_content(@product.seo_title) }
      within('head') do
        page.should have_selector('meta', :name => "description", :content => @product.seo_description)
        page.should have_selector('meta', :name => "keywords", :content => @product.seo_keywords)  
      end
    end
  end
end