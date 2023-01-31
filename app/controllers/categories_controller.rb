class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :show]
  before_action :require_admin, except: [:index, :show]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category was successfully created"
      redirect_to @category
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category name updated successfully"
      redirect_to @category
    else
      render 'edit'
    end
  end

  def index
    @categories = Category.all
  end

  def show
    @problems = @category.problems
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def require_admin
    if !logged_in? || !current_user.admin?
      flash[:alert] = "Only admins can perform that action"
      redirect_to categories_path
    end
  end
end