class ContactController < ApplicationController
  before_filter :get_page

  def index
    @contact = Contact.new
    render :template => "pages/show"
  end

  def submit
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      ContactMailer.contact(@contact).deliver
      flash[:notice] = "Thank you for sending your contact request!"
    else
      flash[:warning] = "There was a problem with your contact submission. Please see error messages below."
    end
    render :template => "pages/show"
  end

  private
    def get_page
      @page = Page.find_by_key('contact-us')
    end
end
