require 'spec_helper'

describe Forge::UsersController do
  describe "As an admin" do
    fixtures :users, :roles
    before do
      controller.stub!(:current_user).and_return(users(:admin))
    end
  
    # NEW
    describe "GET users/new" do
      before do
        get :new
      end
    
      it "should assign @user" do
        assigns[:user].should_not be_nil
      end
    
      it "should render the new template" do
        response.should render_template('new')
      end
    end
  
    # EDIT
    describe "GET users/:id/edit" do
      before do
        @user = mock_model(User)
        User.should_receive(:find).with("1").and_return(@user)
        get :edit, :id => 1
      end
    
      it "should assign @user" do
        assigns[:user].should == @user
      end
    
      it "should render the edit template" do
        response.should render_template('edit')
      end
    end
  

    # CREATE
    describe "POST users/" do
      def do_create
        post :create, :user => {}
      end
    
      describe "with valid attributes" do    
        before do
          @user = mock_model(User, :save => true)     
          @user.stub!(:role_ids).and_return([])  
          @user.stub!(:role_ids=).and_return([])       
          User.stub!(:new).and_return(@user)
          
      
        end
      
        it "should assign @user" do
          do_create
          assigns[:user].should == @user
        end
      
        it "should set the flash notice" do
          do_create
          flash[:notice].should_not be_nil
        end
      
        it "should redirect to the index" do
          do_create
          response.should redirect_to(forge_users_path)
        end
      
        it "should be valid" do
          @user.should_receive(:save).and_return(:true)
          do_create
        end
      end
    
      describe "with invalid attributes" do
        before do
          @user = mock_model(User, :save => false)
          @user.stub!(:role_ids).and_return([])
          @user.stub!(:role_ids=).and_return([])       
                    
          User.stub!(:new).and_return(@user)
        end
      
        it "should assign @user" do
          do_create
          assigns[:user].should == @user
        end
      
        it "should not set the flash notice" do
          do_create
          flash[:notice].should be_nil
        end
      
        it "should render the new template" do
          do_create
          response.should render_template('new')
        end
      
        it "should not save" do
          @user.should_receive(:save).and_return(:false)
          do_create
        end
      end
    end
  
    # UPDATE
    describe "PUT users/:id" do
      def do_update
        put :update, :id => "1", :user => {}
      end    
    
      describe "with valid params" do
        before(:each) do
          @user = mock_model(User, :update_attributes => true)
          @user.stub!(:role_ids=).and_return([])
          User.stub!(:find).with("1").and_return(@user)
        end
  
        it "should find user and return object" do
          do_update
          assigns[:user].should == @user
        end
  
        it "should update the user object's attributes" do
          @user.should_receive(:update_attributes)
          do_update
        end
  
        it "should redirect to the user index page" do
          do_update
          response.should redirect_to(forge_users_path)
        end
      end
  
      describe "with invalid params" do
        before(:each) do
          @user = mock_model(User, :update_attributes => false)
          @user.stub!(:role_ids=).and_return([])
          User.stub!(:find).with("1").and_return(@user)
        end
  
        it "should find user and return object" do
          do_update
          assigns[:user].should == @user
        end
  
        it "should update the user object's attributes" do
          @user.should_receive(:update_attributes)
          do_update
        end
  
        it "should render the edit form" do
          do_update
          response.should render_template('edit')
        end
  
        it "should not have a flash notice" do
          do_update
          flash[:notice].should be_blank
        end
      end
  
    end
    
    # DESTROY
    describe "DELETE /users/:id" do
      it "should delete" do
        @user = mock_model(User)
        User.stub!(:find).and_return(@user)
        @user.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end
  end
  
  
  describe "As someone who's not logged in" do
    before do
      controller.stub!(:current_user).and_return(nil)
    end
    
    it "should not let you get the new action" do
      get :new
      response.should redirect_to('/login')
    end
    
    it "should not let you get the edit action" do
      get :edit, :id => 1
      response.should redirect_to('/login')
    end
    
    it "should not let you get the create action" do
      post :create
      response.should redirect_to('/login')
    end
    
    it "should not let you get the update action" do
      put :update, :id => 1
      response.should redirect_to('/login')
    end
    
    it "should not let you get the destroy action" do
      delete :destroy, :id => 1
      response.should redirect_to('/login')
    end
  end
end