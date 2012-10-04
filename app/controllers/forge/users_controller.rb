class Forge::UsersController < ForgeController
  load_and_authorize_resource
  before_filter :get_roles, :only => [:new, :edit, :update, :create]
  
  def index
    respond_to do |format|
      format.html { @users = User.paginate(:per_page => 10, :page => params[:page]) }
      format.js { 
        @users = User.where("email LIKE ?", "%#{params[:q]}%")
        render :partial => "user", :collection => @users
      }
    end
  end

  def new
    @user = User.new
  end


  def create
    @user = User.new(params[:user])
    @user.role_ids = params[:user][:role_ids]
    @user.approved = true unless @user.role_ids.join(" ").match(/1|2/).blank?
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to(forge_users_path)
    else
      render :action => "new"
    end
  end

  def update
    params[:user].delete_if { |key, value| [:password, :password_confirmation].include?(key.to_sym) && value.blank? } # passing blank password causes devise to poop
    @user.role_ids = params[:user][:role_ids]
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to(forge_users_path)
    else
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy
    redirect_to(forge_users_path)
  end
  
  def approve
    if @user.id == current_user.id
      flash[:warning] = 'You cannot unapprove yourself'
    else
      @user.approved = @user.approved? ? false : true
      @user.save
      UserMailer.approved(@user).deliver if @user.approved?
    end
    redirect_to forge_users_path
  end
  
  private
    def get_roles
      @roles = Role.all
    end
end
