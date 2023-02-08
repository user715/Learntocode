class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :show, :destroy]
  before_action :require_admin, except: [:index, :show, :destroy]

  def new
    @category = Category.new
  end

  def create
    if !params[:name]
      @category = Category.new(category_params)
      if @category.save
        flash[:notice] = "Category was successfully created"
      else
        flash[:alert] = "Category already exists"
      end
      redirect_to categories_path
    else
      @category = Category.new
      @category.name = params[:name]
      if @category.save
        flash.now[:notice] = "Category was successfully created"
      else
        flash.now[:alert] = "Category already exists"
      end
      @categories = Category.all
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

  def destroy
    @category.destroy
    redirect_to categories_path
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