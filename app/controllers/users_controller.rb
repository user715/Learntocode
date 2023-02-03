class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update, :toggle_like]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
    @problems = @user.liked_problems
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
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
    @user.liked_problems.each do |problem|
      problem.likes -= 1
      problem.save
    end
    session[:user_id] = nil if @user == current_user
    @user.destroy
    flash[:notice] = "Account was successfully deleted"
    redirect_to problems_path
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

  # def solve_problem
  #   @problem = Problem.find(params[:problem_id])
  #   if logged_in? && !current_user.problems_solved.exists?(@problem.id)
  #     current_user.problems_solved << @problem
  #     difficulty = Tag.find(@problem.tag_id)
  #     if difficulty = "Easy"
  #       current_user.easysolved += 1
  #     elsif difficulty = "Medium"
  #       current_user.mediumsolved += 1
  #     else
  #       current_user.difficultsolved += 1
  #     end
  #   end
  # end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own account"
      redirect_to @user
    end
  end

end