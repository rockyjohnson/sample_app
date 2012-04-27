class UsersController < ApplicationController
 before_filter :authenticate,
               :only => [:index,:edit, :update,:destroy]
 before_filter :correct_user, :only => [:edit, :update]
 before_filter :admin_user, :only => :destroy
def index
@title = "All users"
@users = User.paginate(:page => params[:page])
end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
def new
unless signed_in?
 @user=User.new
 @title="Sign up"
else 
flash[:info] = " You already logged in, so you can not create new account"
redirect_to root_path
end
  end 
def create
@user = User.new(params[:user])
if @user.save
sign_in @user
flash[:success] = "Welcome to the Sample App!"
redirect_to @user
else
@title = "Sign up"
render 'new'
end
end
def edit
    @title = "Edit user"
  end
def update
    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success => "Profile updated." }
    else
      @title = "Edit user"
      render 'edit'
    end
end
def destroy
@user = User.find(params[:id])
if current_user == @user
  flash[:notice] = "You cannot delete yourself."
else
  @user.destroy
  flash[:success] = "User destroyed."
end
redirect_to users_path
end
private
	def authenticate 
		deny_access unless signed_in?

  end
 def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(@user)
    end
end
