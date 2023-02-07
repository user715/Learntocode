class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update, :toggle_like]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
    
  end

  def index
    @users = User.all
    sort_leaderboard
    @users = @users.sort_by { |user| user.rank }
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.rank = User.all.count + 1
    @user.score = 0
    if @user.save
      session[:user_id] = @user.id
      sort_leaderboard
      flash[:notice] = "Welcome to Learntocode #{@user.username}, you have successfully sign up"
      redirect_to users_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account information was successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if @user.admin?
      flash[:alert] = "Admin account cant be deleted"
      redirect_to problems_path
    else
      @user.liked_problems.each do |problem|
        problem.likes -= 1
        problem.save
      end
      session[:user_id] = nil if @user == current_user
      @user.destroy
      sort_leaderboard
      flash[:notice] = "Account was successfully deleted"
      redirect_to problems_path
    end
  end

  def toggle_like
    @problem = Problem.find(params[:id])
    if current_user.liked_problems.exists?(@problem.id)
      current_user.liked_problems.delete(@problem)
      @problem.likes -= 1
    else
      current_user.liked_problems << @problem
      @problem.likes += 1
    end
    @problem.save
    # redirect_to problems_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    # byebug
    if !User.exists?(params[:id])
      flash[:alert] = "Profile not found"
      redirect_to users_path
    else
      @user = User.find(params[:id])
    end
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own account"
      redirect_to @user
    end
  end


end