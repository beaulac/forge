class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  layout :layout_by_resource
  before_filter :app_init
  
  def app_init
    # application-wide init stuff here
  end
  
  protected
    def get_cart_order
      @cart_order = Order.where(:key => cookies[:order_key], :state => "pending").first if cookies[:order_key]
    end

    def layout_by_resource
      if devise_controller?
        "forge_login"
      else
        "application"
      end
    end
    
    def after_sign_in_path_for(resource) 
      if resource.staff? 
        '/forge' 
      else 
        super 
      end 
    end
    
    def require_admin
      unless current_user && current_user.staff?
        flash[:warning] = "You're not authorized for that." if current_user
        redirect_to '/login'
      end
    end
    
    def get_archive_months
      @months = Post.get_archive_months
    end
    
    def get_post_categories
      @post_categories = PostCategory.all(:order => "title")
    end

    def require_addresses_for_checkout
      unless @cart_order.valid_addresses?
        redirect_to "orders/checkout"
        return false
      end
    end
    
end
