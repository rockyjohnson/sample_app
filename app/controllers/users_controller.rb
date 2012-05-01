class UsersController < ApplicationController
  before_filter :authenticate, :except     => [:show, :new, :create]
  before_filter :correct_user, :only       => [:edit, :update]
  before_filter :admin_user,   :only       => :destroy
  before_filter :redirect_signed_in, :only => [:new, :create]

  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name 
    @microposts = @user.microposts.paginate(:page => params[:page])
  end
  
  def new
    @user = User.new #initializes a new user, does not need options hash
    @title = "Sign up"
  end

  def following
    show_follow(:following)
  end
  
  def followers
    show_follow(:followers)
  end

  def show_follow(action)
    @title = action.to_s.capitalize
    @user  = User.find(params[:id])
    @users = @user.send(action).paginate(:page => params[:page])
    render 'show_follow'
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { 
                         :success => "Welcome to the Sample App!" }
    else      
      @title = "Sign up"
      @user.password = nil
      @user.password_confirmation = nil
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated!" }
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :flash => { :success => "User destroyed!" }
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) if !current_user.admin? || current_user?(@user)
  end

  def redirect_signed_in
    redirect_to(root_path) if signed_in?
  end
end
